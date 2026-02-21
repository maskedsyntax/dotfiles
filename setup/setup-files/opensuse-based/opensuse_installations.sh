#!/bin/bash

# ============================================
# OpenSUSE Tumbleweed/Leap Setup Script
# ============================================

set -e # Exit on error

# Log file
LOGFILE="$HOME/opensuse_setup.log"
exec &> >(tee -a "$LOGFILE")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}==>${NC} ${GREEN}$1${NC}"
}

print_error() {
    echo -e "${RED}ERROR:${NC} $1"
}

# 1. Update System
print_status "Updating system..."
sudo zypper --non-interactive dup

# 2. Enable Packman Repository (Codecs)
print_status "Enabling Packman Repository for codecs..."
sudo zypper --non-interactive addrepo -f http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman || true
sudo zypper --non-interactive --gpg-auto-import-keys refresh
sudo zypper --non-interactive dist-upgrade --from packman --allow-vendor-change

# 3. NVIDIA Support
print_status "Installing NVIDIA drivers..."
sudo zypper --non-interactive addrepo -f https://download.nvidia.com/opensuse/tumbleweed nvidia || true
sudo zypper --non-interactive refresh
sudo zypper --non-interactive install nvidia-video-G06 nvidia-gl-G06 nvidia-compute-G06 nvidia-utils-G06

# 4. Bluetooth Support
print_status "Installing Bluetooth support..."
sudo zypper --non-interactive install bluez bluez-tools blueman
sudo systemctl enable --now bluetooth

# 5. Git Configuration
setup_git() {
    print_status "Configuring Git..."
    git config --global user.name "maskedsyntax"
    git config --global user.email "aftaab@aftaab.xyz"
    git config --global credential.helper store
    git config --global core.editor "vim"
    git config --global pull.rebase true
    git config --global init.defaultBranch master
}
setup_git

# 6. Essential CLI Tools & UV
print_status "Installing development patterns, essential tools and uv..."
sudo zypper --non-interactive install -t pattern devel_basis devel_C_C++
sudo zypper --non-interactive install \
    vim gvim neovim xsel htop fastfetch \
    zsh tree tmux wget unzip curl git \
    bash-completion openssh cloc \
    nodejs npm \
    python3-pip python3-devel \
    ripgrep fd findutils
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# 7. Programming Languages
print_status "Installing Programming Languages..."
sudo zypper --non-interactive install java-21-openjdk-devel go
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# Flutter & Dart (Manual Installation to /opt)
if [ ! -d "/opt/flutter" ]; then
    print_status "Installing Flutter and Dart to /opt..."
    sudo git clone https://github.com/flutter/flutter.git -b stable /opt/flutter
    sudo chown -R $USER:$USER /opt/flutter
    if ! grep -q "/opt/flutter/bin" ~/.zshrc; then
        echo 'export PATH="$PATH:/opt/flutter/bin"' >> ~/.zshrc
    fi
fi

# 8. Fonts
print_status "Installing Fonts..."
sudo zypper --non-interactive install \
    cascadia-fonts jetbrains-mono-fonts fira-code-fonts \
    google-roboto-fonts google-noto-fonts

# 9. Third-Party Repos (VS Code, Sublime, Brave)
print_status "Configuring third-party repositories..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo zypper --non-interactive addrepo https://packages.microsoft.com/yumrepos/vscode vscode || true
sudo rpm --import https://download.sublimetext.com/sublimehq-pub.gpg
sudo zypper --non-interactive addrepo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo sublime-text || true
sudo zypper --non-interactive addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo brave || true
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

sudo zypper --non-interactive refresh
sudo zypper --non-interactive install code sublime-text brave-browser

# 10. GUI Applications & Default Tools
print_status "Installing GUI Applications and Default Tools..."
sudo zypper --non-interactive install \
    vlc mpv gimp krita inkscape obs-studio \
    pavucontrol flameshot \
    alacritty kitty epiphany \
    chromium-browser thunar thunar-archive-plugin file-roller \
    okular viewnior libreoffice xdg-utils firefox

# 11. Flatpak & Specialty Apps
print_status "Enabling Flatpak and installing apps..."
sudo zypper --non-interactive install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub -y \
    com.getpostman.Postman \
    rest.insomnia.Insomnia \
    com.discordapp.Discord \
    com.slack.Slack \
    com.spotify.Client \
    com.getcursor.Cursor \
    com.github.th_ch.youtube_music

# 12. Specialty Editors & AI Tools
print_status "Installing Specialty Editors & AI Tools..."
curl -f https://zed.dev/install.sh | sh
sudo zypper --non-interactive install helix
sudo npm install -g @google/gemini-cli @anthropic-ai/claude-code

# 13. Android Studio & IntelliJ (Manual Installation to /opt)
install_jetbrains_manual() {
    local name=$1
    local url=$2
    local target_dir="/opt/$name"
    if [ ! -d "$target_dir" ]; then
        print_status "Installing $name to /opt..."
        local temp_tar=$(mktemp)
        curl -L "$url" -o "$temp_tar"
        sudo mkdir -p "$target_dir"
        sudo tar -xzf "$temp_tar" -C "$target_dir" --strip-components=1
        sudo chown -R $USER:$USER "$target_dir"
        rm "$temp_tar"
        
        local exec_path="$target_dir/bin/${name/android-studio/studio}.sh"
        if [ "$name" == "intellij-idea" ]; then exec_path="$target_dir/bin/idea.sh"; fi
        
        cat <<EOF | sudo tee /usr/share/applications/$name.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=$name
Icon=$target_dir/bin/${name/android-studio/studio}.png
Exec="$exec_path" %f
Comment=Professional IDE
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-${name/intellij-idea/idea}
EOF
    fi
}

install_jetbrains_manual "android-studio" "https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2024.3.1.13/android-studio-2024.3.1.13-linux.tar.gz"
install_jetbrains_manual "intellij-idea" "https://download.jetbrains.com/product?code=IIC&latest&type=release&platform=linux"

# 14. Set Default Applications
print_status "Setting default applications..."
xdg-settings set default-web-browser firefox.desktop
xdg-mime default org.kde.okular.desktop application/pdf
xdg-mime default viewnior.desktop image/png image/jpeg image/gif
xdg-mime default thunar.desktop inode/directory

# 15. Shell Customization
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

print_status "OpenSUSE Setup Complete! Check $LOGFILE for details."
