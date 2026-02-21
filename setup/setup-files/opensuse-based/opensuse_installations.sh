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

# 3. Essential CLI Tools & Dev Essentials
print_status "Installing development patterns and essential tools..."
sudo zypper --non-interactive install -t pattern devel_basis devel_C_C++
sudo zypper --non-interactive install 
    vim gvim neovim xsel htop fastfetch 
    zsh tree tmux wget unzip curl git 
    bash-completion openssh cloc 
    nodejs npm 
    python3-pip python3-devel 
    ripgrep fd findutils --no-confirm

# 4. Programming Languages
print_status "Installing Programming Languages..."
# Java
sudo zypper --non-interactive install java-21-openjdk-devel
# Go
sudo zypper --non-interactive install go
# Rust
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# 5. Fonts
print_status "Installing Fonts..."
sudo zypper --non-interactive install 
    cascadia-fonts jetbrains-mono-fonts fira-code-fonts 
    google-roboto-fonts google-noto-fonts

# 6. Third-Party Repos (VS Code, Sublime)
print_status "Configuring VS Code and Sublime repositories..."
# VS Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo zypper --non-interactive addrepo https://packages.microsoft.com/yumrepos/vscode vscode
# Sublime Text
sudo rpm --import https://download.sublimetext.com/sublimehq-pub.gpg
sudo zypper --non-interactive addrepo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo sublime-text

sudo zypper --non-interactive refresh
sudo zypper --non-interactive install code sublime-text

# 7. GUI Applications
print_status "Installing GUI Applications..."
sudo zypper --non-interactive install 
    vlc mpv gimp krita inkscape obs-studio 
    pavucontrol flameshot 
    alacritty kitty epiphany 
    chromium-browser

# 8. Brave Browser
print_status "Installing Brave Browser..."
sudo zypper --non-interactive addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo zypper --non-interactive install brave-browser

# 9. Flatpak & Essential Apps
print_status "Enabling Flatpak and installing apps..."
sudo zypper --non-interactive install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub -y 
    com.getpostman.Postman 
    rest.insomnia.Insomnia 
    com.discordapp.Discord 
    com.slack.Slack 
    io.github.mimbrero.WhatsAppDesktop 
    com.github.th_ch.youtube_music

# 10. Specialty Editors
print_status "Installing Zed and Helix..."
curl -f https://zed.dev/install.sh | sh
sudo zypper --non-interactive install helix

# 11. Shell Customization
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 12. AI Tools
print_status "Installing AI Tools (Cursor, Gemini CLI, Claude Code)..."
flatpak install flathub -y com.getcursor.Cursor
sudo npm install -g @google/gemini-cli @anthropic-ai/claude-code

print_status "OpenSUSE Setup Complete! Check $LOGFILE for details."
