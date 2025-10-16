#!/bin/bash

set -e # Exit on any error

echo -e "===============================================\n"
echo -e "Updating system and installing essential apps\n"
echo -e "===============================================\n"
sudo apt update && sudo apt upgrade -y

# Basic tools & dev essentials
sudo apt install -y \
    build-essential curl wget unzip git python3-pip clang clangd clang-format black shfmt \
    vim-gtk3 htop neofetch xsel nodejs npm yarn tree tmux ubuntu-restricted-extras \
    fonts-firacode fonts-cascadia-code fonts-jetbrains-mono fonts-ibm-plex \
    alacritty kitty \
    openjdk-21-jdk-headless openjdk-21-jre-headless \
    gimp krita inkscape obs-studio vlc mpv geany dconf-editor \
    epiphany-browser \
    cmake ninja-build gdb lldb valgrind cloc flatpak \
    dmz-cursor-theme thunar pavucontrol gnuplot flameshot fastfetch

# Install Papirus Icon Pack
echo -e "===============================================\n"
echo -e "Installing Papirus Icon Pack\n"
echo -e "===============================================\n"
sudo sh -c "echo 'deb http://ppa.launchpad.net/papirus/papirus/ubuntu jammy main' > /etc/apt/sources.list.d/papirus-ppa.list"
sudo wget -qO /etc/apt/trusted.gpg.d/papirus-ppa.asc 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x9461999446FAF0DF770BFC9AE58A9D36647CAE7F'
sudo apt-get update
sudo apt-get install -y papirus-icon-theme

echo -e "===============================================\n"
echo -e "Installing Brave Browser\n"
echo -e "===============================================\n"
curl -fsS https://dl.brave.com/install.sh | sh

echo -e "===============================================\n"
echo -e "Installing Helix Editor\n"
echo -e "===============================================\n"
curl -LO https://github.com/helix-editor/helix/releases/latest/download/helix-x86_64-linux.tar.xz
tar -xf helix-x86_64-linux.tar.xz
sudo mv helix-*/hx /usr/local/bin/
rm -rf helix-*

echo -e "===============================================\n"
echo -e "Installing Oh My Zsh\n"
echo -e "===============================================\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/maskedsyntax/ohmyzsh/master/tools/install.sh)"

echo -e "===============================================\n"
echo -e "Installing Zed Editor\n"
echo -e "===============================================\n"
curl -f https://zed.dev/install.sh | sh

echo -e "===============================================\n"
echo -e "Installing Node.js LTS via NVM\n"
echo -e "===============================================\n"
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
node --version

echo -e "===============================================\n"
echo -e "Installing Go 1.25.3\n"
echo -e "===============================================\n"
wget https://go.dev/dl/go1.25.3.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.25.3.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.zshrc
source ~/.zshrc
go version

echo -e "===============================================\n"
echo -e "Installing Go tools\n"
echo -e "===============================================\n"
go install golang.org/x/tools/gopls@latest
go install github.com/nametake/golangci-lint-langserver@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

echo -e "===============================================\n"
echo -e "Installing Rust and tools\n"
echo -e "===============================================\n"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
rustup component add rustfmt rust-analyzer
cargo install taplo-cli

echo -e "===============================================\n"
echo -e "Installing Language Servers & Formatters\n"
echo -e "===============================================\n"
npm install -g \
    pyright \
    bash-language-server \
    yaml-language-server \
    prettier \
    vscode-langservers-extracted

echo -e "===============================================\n"
echo -e "Installing Sublime Text 4\n"
echo -e "===============================================\n"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https -y
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text -y

echo -e "===============================================\n"
echo -e "Installing lldb-dap-20 and creating symlink\n"
echo -e "===============================================\n"
sudo apt install -y lldb-dap-20
sudo ln -sf /usr/bin/lldb-dap-20 /usr/local/bin/lldb-dap

echo -e "===============================================\n"
echo -e "Installing Chromium via Flatpak\n"
echo -e "===============================================\n"
flatpak install -y flathub org.chromium.Chromium

echo -e "===============================================\n"
echo -e "Configuring Git\n"
echo -e "===============================================\n"
git config --global user.name "maskedsyntax"
git config --global user.email "aftaab@aftaab.xyz"
git config --global credential.helper store
git config --global core.editor "hx"

echo -e "===============================================\n"
echo -e "                    DONE                       "
echo -e "===============================================\n"
