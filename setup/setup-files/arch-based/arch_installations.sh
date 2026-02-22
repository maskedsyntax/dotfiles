#!/bin/bash

# ============================================
# Arch Linux Professional Setup Script
# ============================================

set -e # Exit on error

# Log file
LOGFILE="$HOME/arch_setup.log"
exec &> >(tee -a "$LOGFILE")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}==>${NC} ${GREEN}$1${NC}"
}

print_error() {
    echo -e "${RED}ERROR:${NC} $1"
}

# 1. Update System
print_status "Updating system..."
sudo pacman -Syu --noconfirm

# 2. Install Base Development Tools & Git
print_status "Installing base-devel and git..."
sudo pacman -S --needed base-devel git --noconfirm

# 3. Git Configuration
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

# 4. Install AUR Helper: yay
if ! command -v yay &> /dev/null; then
    print_status "Installing yay (AUR helper)..."
    TEMP_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$TEMP_DIR"
    cd "$TEMP_DIR"
    makepkg -si --noconfirm
    cd -
    rm -rf "$TEMP_DIR"
else
    print_status "yay is already installed."
fi

# 5. NVIDIA Support
print_status "Installing NVIDIA drivers and tools..."
# sudo pacman -S --needed nvidia nvidia-utils nvidia-settings lib32-nvidia-utils --noconfirm

# 6. Bluetooth Support
print_status "Installing Bluetooth support..."
sudo pacman -S --needed bluez bluez-utils blueman --noconfirm
sudo systemctl enable --now bluetooth

# 7. Essential CLI Tools & UV
print_status "Installing essential CLI tools and uv..."
sudo pacman -S --needed \
    neovim xsel htop btop fastfetch \
    zsh tree tmux wget unzip curl \
    bash-completion openssh cloc \
    nodejs npm yarn uv \
    python-pip \
    ripgrep fd findutils --noconfirm

# 8. Programming Languages (JDK, Go, Rust, Flutter, Dart)
print_status "Installing Programming Languages..."
sudo pacman -S --needed jdk-openjdk go --noconfirm

# Rust
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
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
sudo pacman -S --needed \
    ttf-cascadia-code ttf-jetbrains-mono ttf-fira-code \
    ttf-fira-mono \
    adobe-source-code-pro-fonts --noconfirm

# 10. GUI Applications & Default Tools
print_status "Installing GUI Applications and Default Tools..."
sudo pacman -S --needed \
    vlc mpv gimp krita inkscape obs-studio \
    pavucontrol flameshot picom \
    polybar \
    alacritty kitty thunar thunar-archive-plugin file-roller \
    epiphany okular viewnior libreoffice-fresh xdg-utils \
    firefox thunderbird mousepad telegram-desktop gnome-system-monitor steam --noconfirm

# AUR Apps
yay -S --needed \
    google-chrome brave-bin visual-studio-code-bin \
    sublime-text-4 spotify rnote \
    postman-bin insomnia-bin youtube-music-bin \
    discord slack-desktop \
    siji-git ttf-font-awesome-5 \
    python-mpd2 --noconfirm

# 11. Specialty Editors & AI Tools
print_status "Installing Specialty Editors & AI Tools..."
curl -f https://zed.dev/install.sh | sh
sudo pacman -S --needed helix --noconfirm
yay -S --needed cursor-bin --noconfirm
sudo npm install -g @google/gemini-cli @anthropic-ai/claude-code

# 12. Android Studio & IntelliJ (Manual Installation to /opt)
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

# 13. Set Default Applications
print_status "Setting default applications..."
xdg-settings set default-web-browser firefox.desktop
xdg-mime default org.kde.okular.desktop application/pdf
xdg-mime default viewnior.desktop image/png image/jpeg image/gif
xdg-mime default thunar.desktop inode/directory

# 14. Vim-Plug Setup
setup_vim_plug() {
    print_status "Installing vim-plug for Vim..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    
    print_status "Installing vim-plug for Neovim..."
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}
setup_vim_plug

# 15. Shell Customization
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

print_status "Arch Setup Complete! Check $LOGFILE for details."
