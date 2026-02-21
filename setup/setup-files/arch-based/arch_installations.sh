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

# 3. Install AUR Helper: yay
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

# 4. Essential CLI Tools
print_status "Installing essential CLI tools..."
sudo pacman -S --needed \
    vim gvim neovim xsel htop fastfetch \
    zsh tree tmux wget unzip curl \
    bash-completion openssh cloc \
    nodejs npm yarn bun-bin \
    python-pip python-pyright \
    ripgrep fd findutils --noconfirm

# 5. Development Environments (Languages)
print_status "Installing Development Environments..."
# Java
sudo pacman -S --needed jdk-openjdk --noconfirm
# Rust
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi
# Go
sudo pacman -S --needed go --noconfirm

# 6. Fonts
print_status "Installing Fonts..."
sudo pacman -S --needed \
    ttf-cascadia-code ttf-jetbrains-mono ttf-fira-code \
    adobe-source-code-pro-fonts --noconfirm

# 7. GUI Applications (Browsers, IDEs, etc.)
print_status "Installing GUI Applications..."
# Standard Repos
sudo pacman -S --needed \
    vlc mpv gimp krita inkscape obs-studio \
    pavucontrol nitrogen flameshot \
    alacritty kitty thunar epiphany --noconfirm

# AUR Apps
yay -S --needed \
    google-chrome brave-bin visual-studio-code-bin \
    sublime-text-4 jetbrains-toolbox \
    postman-bin insomnia-bin youtube-music-bin \
    telegram-desktop-bin whatsapp-for-linux \
    discord slack-desktop --noconfirm

# 8. Specialty Editors (via scripts)
print_status "Installing Zed and Helix..."
curl -f https://zed.dev/install.sh | sh
sudo pacman -S --needed helix --noconfirm

# 9. Flatpak (Optional support)
print_status "Ensuring Flatpak is installed..."
sudo pacman -S --needed flatpak --noconfirm

# 10. Shell Customization
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 11. AI Tools
print_status "Installing AI Tools (Cursor, Gemini CLI, Claude Code)..."
yay -S --needed cursor-bin --noconfirm
sudo npm install -g @google/gemini-cli @anthropic-ai/claude-code

print_status "Arch Setup Complete! Check $LOGFILE for details."
