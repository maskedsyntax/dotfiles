#!/bin/bash

# ============================================
# Arch Linux Setup Script
# ============================================

# Log file location
LOGFILE="$HOME/arch_setup.log"
exec &> >(tee -a "$LOGFILE")  # Log all output to the log file

# Function to check for command success
check_success() {
    if [[ $? -ne 0 ]]; then
        echo -e "\nERROR: $1 failed. Exiting script.\n" | tee -a "$LOGFILE"
        exit 1
    fi
}

# Function to install packages using pacman or yay
install_package() {
    PACKAGE=$1
    INSTALLER=$2
    if ! pacman -Q "$PACKAGE" &>/dev/null; then
        echo -e "Installing $PACKAGE..."
        $INSTALLER $PACKAGE --noconfirm
        check_success "$PACKAGE installation"
    else
        echo -e "$PACKAGE is already installed. Skipping...\n"
    fi
}

# Function to update the system
update_system() {
    echo -e "===============================================\n"
    echo -e "Updating the system...\n"
    echo -e "===============================================\n"
    sudo pacman -Syu --noconfirm
    check_success "System update"
}

# ============================================
# Install Base Development Tools
# ============================================
install_base_tools() {
    echo -e "===============================================\n"
    echo -e "Installing Base Development Tools: base-devel, git\n"
    echo -e "===============================================\n"
    sudo pacman -S --needed base-devel git --noconfirm
    check_success "Base development tools installation"
}

# ============================================
# Install AUR Helper: yay
# ============================================
install_yay() {
    echo -e "===============================================\n"
    echo -e "Installing AUR helper: yay\n"
    echo -e "===============================================\n"
    if ! pacman -Q yay &>/dev/null; then
        git clone https://aur.archlinux.org/yay.git
        check_success "Git clone yay"
        cd yay
        makepkg -si --noconfirm
        check_success "yay installation"
        cd ~
    else
        echo -e "yay is already installed. Skipping...\n"
    fi
}

# ============================================
# Installing Essential Apps
# ============================================
install_essential_apps() {
    echo -e "===============================================\n"
    echo -e "Installing essential apps: Vim, Neovim, xsel, nodejs, npm, yarn, zsh, tree, tmux\n"
    echo -e "===============================================\n"
    sudo pacman -S --needed gvim pavucontrol nitrogen htop neovim fastfetch xsel nodejs npm yarn zsh tree tmux --noconfirm
    check_success "Essential apps installation"
}

# ============================================
# Installing Fonts
# ============================================
install_fonts() {
    echo -e "===============================================\n"
    echo -e "Installing Fonts: Courier-Code and JetBrainsMono\n"
    echo -e "===============================================\n"
    yay -S --needed ttf-courier-code ttf-jetbrains-mono --noconfirm
    check_success "Font installation"
}

# ============================================
# Installing Java (JDK & JRE)
# ============================================
install_java() {
    echo -e "===============================================\n"
    echo -e "Installing JAVA (Latest: jdk-23 & jre-23)\n"
    echo -e "===============================================\n"
    yay -S --needed jdk --noconfirm
    check_success "Java installation"
}

# ============================================
# Installing Browsers
# ============================================
install_browsers() {
    echo -e "===============================================\n"
    echo -e "Installing Browsers: Google Chrome, Epiphany, Brave\n"
    echo -e "===============================================\n"
    curl -fsS https://dl.brave.com/install.sh | sh
    check_success "Browser installation"
}

# ============================================
# Installing IDEs and Text Editors
# ============================================
install_ides_and_editors() {
    echo -e "===============================================\n"
    echo -e "Installing IDEs and Text Editors\n"
    echo -e "===============================================\n"
    yay -S --needed jetbrains-toolbox visual-studio-code-bin --noconfirm
    yay -S --needed sublime-text-4 --noconfirm
    check_success "IDEs and text editors installation"
}

# ============================================
# Installing Development Tools
# ============================================
install_dev_tools() {
    echo -e "===============================================\n"
    echo -e "Installing Dev Tools: GitHub Desktop, GIMP, Krita, OBS Studio\n"
    echo -e "===============================================\n"
    yay -S --needed postman-bin insomnia-bin github-desktop-bin gimp krita obs-studio --noconfirm
    check_success "Development tools installation"
}

# ============================================
# Installing Other Apps
# ============================================
install_other_apps() {
    echo -e "===============================================\n"
    echo -e "Installing Other Apps: VLC, Inkscape, YouTube Music, Telegram, Discord, Slack, WhatsApp, Alacritty\n"
    echo -e "===============================================\n"
    sudo pacman -S --needed vlc --noconfirm
    yay -S --needed youtube-music-desktop telegram-desktop-bin okular libreoffice-still whatsapp-for-linux discord slack-desktop --noconfirm
    yay -S --needed alacritty --noconfirm
    check_success "Other apps installation"
}

# ============================================
# Installing Flatpak (Optional)
# ============================================
install_flatpak() {
    echo -e "===============================================\n"
    echo -e "Installing Flatpak\n"
    echo -e "===============================================\n"
    sudo pacman -S --needed flatpak --noconfirm
    check_success "Flatpak installation"
}

# ============================================
# Installing Bash Completion
# ============================================
install_bash_completion() {
    echo -e "===============================================\n"
    echo -e "Installing Bash Completion\n"
    echo -e "===============================================\n"
    sudo pacman -S --needed bash-completion --noconfirm
    check_success "Bash Completion installation"

    # Enable bash completion in ~/.bashrc if not already enabled
    if ! grep -q "bash-completion" ~/.bashrc; then
        echo -e "\n# Enable bash-completion if available\nif [ -f /usr/share/bash-completion/bash_completion ]; then\n    . /usr/share/bash-completion/bash_completion\nfi" >> ~/.bashrc
        source ~/.bashrc
    fi
}

# ============================================
# Installing vim-plug for Vim and Neovim
# ============================================
install_vim_plug() {
    echo -e "===============================================\n"
    echo -e "Installing vim-plug for Vim\n"
    echo -e "===============================================\n"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    check_success "vim-plug installation for Vim"

    echo -e "===============================================\n"
    echo -e "Installing vim-plug for Neovim\n"
    echo -e "===============================================\n"
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    check_success "vim-plug installation for Neovim"
}

# ============================================
# Run All Functions
# ============================================
update_system
install_base_tools
install_yay
install_essential_apps
install_fonts
install_java
install_browsers
install_ides_and_editors
install_dev_tools
install_other_apps
install_flatpak
# install_bash_completion
# install_vim_plug

# ============================================
# Final Message
# ============================================
echo -e "===============================================\n"
echo -e "                    DONE                        \n"
echo -e "===============================================\n"
