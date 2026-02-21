#!/bin/bash

# ============================================
# Fedora Workstation Setup Script
# ============================================

set -e # Exit on error

# Log file
LOGFILE="$HOME/fedora_setup.log"
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
sudo dnf upgrade --refresh -y

# 2. Enable RPM Fusion Repos
print_status "Enabling RPM Fusion (Free and Non-Free)..."
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Enable multimedia libraries and codecs
print_status "Installing multimedia codecs..."
sudo dnf group upgrade --with-optional Multimedia -y
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install -y lame\* --exclude=lame-devel

# 3. NVIDIA Support
print_status "Installing NVIDIA drivers and tools..."
sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda nvidia-settings

# 4. Bluetooth Support
print_status "Installing Bluetooth support..."
sudo dnf install -y bluez bluez-tools blueman
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

# 6. Enable Flatpak (Flathub)
print_status "Enabling Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 7. Essential CLI Tools & UV
print_status "Installing essential CLI tools and uv..."
sudo dnf group install -y "Development Tools" "C Development Tools and Libraries"
sudo dnf install -y \
    vim gvim neovim xsel htop btop fastfetch \
    zsh tree tmux wget unzip curl git \
    bash-completion openssh cloc \
    nodejs npm \
    python3-pip python3-devel \
    ripgrep fd-find findutils
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# 8. Programming Languages
print_status "Installing Programming Languages..."
# Java
sudo dnf install -y java-21-openjdk-devel
# Go
sudo dnf install -y golang
# Rust
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

# 9. Fonts
print_status "Installing Fonts..."
sudo dnf install -y \
    cascadia-code-fonts-all jetbrains-mono-fonts fira-code-fonts \
    google-roboto-fonts google-noto-fonts

# 10. Third-Party Repos (VS Code, Sublime, Brave)
print_status "Configuring third-party repositories..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo rpm --import https://download.sublimetext.com/sublimehq-pub.gpg
sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

sudo dnf update -y
sudo dnf install -y code sublime-text brave-browser

# 11. GUI Applications & Default Tools
print_status "Installing GUI Applications and Default Tools..."
sudo dnf install -y \
    vlc mpv gimp krita inkscape obs-studio \
    pavucontrol flameshot picom \
    alacritty kitty epiphany \
    chromium thunar thunar-archive-plugin file-roller \
    okular viewnior libreoffice xdg-utils firefox \
    thunderbird mousepad telegram-desktop gnome-system-monitor steam

# 12. Flatpak Apps
print_status "Installing Flatpak Apps..."
flatpak install flathub -y \
    com.getpostman.Postman \
    rest.insomnia.Insomnia \
    com.discordapp.Discord \
    com.slack.Slack \
    com.spotify.Client \
    com.getcursor.Cursor \
    com.github.th_ch.youtube_music \
    com.github.flxzt.rnote

# 13. Specialty Editors & AI Tools
print_status "Installing Specialty Editors & AI Tools..."
curl -f https://zed.dev/install.sh | sh
sudo dnf install -y helix
sudo npm install -g @google/gemini-cli @anthropic-ai/claude-code

# 14. Android Studio & IntelliJ (Manual Installation to /opt)
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

# 15. Set Default Applications
print_status "Setting default applications..."
xdg-settings set default-web-browser firefox.desktop
xdg-mime default org.kde.okular.desktop application/pdf
xdg-mime default viewnior.desktop image/png image/jpeg image/gif
xdg-mime default thunar.desktop inode/directory

# 16. Shell Customization
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

print_status "Fedora Setup Complete! Check $LOGFILE for details."
