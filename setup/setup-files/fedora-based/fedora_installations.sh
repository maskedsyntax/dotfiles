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

# 3. Enable Flatpak (Flathub)
print_status "Enabling Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 4. Essential CLI Tools
print_status "Installing essential CLI tools..."
sudo dnf group install -y "Development Tools" "C Development Tools and Libraries"
sudo dnf install -y \
    vim gvim neovim xsel htop fastfetch \
    zsh tree tmux wget unzip curl git \
    bash-completion openssh cloc \
    nodejs npm \
    python3-pip python3-devel \
    ripgrep fd-find findutils --noconfirm

# 5. Programming Languages
print_status "Installing Programming Languages..."
# Java
sudo dnf install -y java-21-openjdk-devel
# Go
sudo dnf install -y golang
# Rust
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# 6. Fonts
print_status "Installing Fonts..."
sudo dnf install -y \
    cascadia-code-fonts-all jetbrains-mono-fonts fira-code-fonts \
    google-roboto-fonts google-noto-fonts

# 7. Third-Party Repos (VS Code, Sublime)
print_status "Configuring VS Code and Sublime repositories..."
# VS Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Sublime Text
sudo rpm --import https://download.sublimetext.com/sublimehq-pub.gpg
sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

sudo dnf update -y
sudo dnf install -y code sublime-text

# 8. GUI Applications
print_status "Installing GUI Applications..."
sudo dnf install -y \
    vlc mpv gimp krita inkscape obs-studio \
    pavucontrol flameshot \
    alacritty kitty epiphany \
    chromium brave-browser

# 9. Flatpak Apps (Recommended for Fedora)
print_status "Installing Flatpak Apps..."
flatpak install flathub -y \
    com.getpostman.Postman \
    rest.insomnia.Insomnia \
    com.discordapp.Discord \
    com.slack.Slack \
    io.github.mimbrero.WhatsAppDesktop \
    com.github.th_ch.youtube_music

# 10. Specialty Editors
print_status "Installing Zed and Helix..."
curl -f https://zed.dev/install.sh | sh
sudo dnf install -y helix

# 11. Shell Customization
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 12. AI Tools
print_status "Installing AI Tools (Cursor, Gemini CLI, Claude Code)..."
flatpak install flathub -y com.getcursor.Cursor
sudo npm install -g @google/gemini-cli @anthropic-ai/claude-code

print_status "Fedora Setup Complete! Check $LOGFILE for details."
