#!/bin/bash

# Installing essential apps
echo -e "===============================================\n"
echo -e "Installing the following apps: \n1. Vim\n2. Neovim\n3. xsel(Clipboard for vim & neovim)\n4. nodejs\n5. npm\n6. yarn\n7. zsh\n8. tree\n9. tmux\n"
echo -e "===============================================\n"
sudo apt install vim-gtk3 htop neovim neofetch xsel nodejs gnome-tweaks curl wget npm yarn tree tmux ubuntu-restricted-extras

# Installing extra fonts
sudo apt install fonts-firacode fonts-cascadia-code

# Uncomment if you want to install zsh
# sudo apt install zsh

# Installing Alacritty Terminal (Using PPA)
echo -e "===============================================\n"
echo -e "Installing Alacritty Terminal (Using PPA)\n"
echo -e "===============================================\n"
sudo add-apt-repository ppa:aslatter/ppa
sudo apt update
sudo apt install alacritty

#installing oh-my-zsh
#echo -e "===============================================\n"
#echo -e "Installing ohmyzsh\n"
#echo -e "===============================================\n"
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting


# Download Spotify for Linux
echo -e "===============================================\n"
echo -e "Installing Spotify for Linux\n"
echo -e "===============================================\n"
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client


# installing brave browser
echo -e "===============================================\n"
echo -e "Installing Brave Browser\n"
echo -e "===============================================\n"
sudo apt install apt-transport-https
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser


# Installing jdk-17 & jre-17
echo -e "===============================================\n"
echo -e "Installing JAVA (jdk-17 & jre-17)\n"
echo -e "===============================================\n"
sudo apt install openjdk-17-jre-headless openjdk-17-jdk-headless


# installing Epiphany browser
echo -e "===============================================\n"
echo -e "Installing Epiphany Browser\n"
echo -e "===============================================\n"
sudo apt install epiphany-browser


# installing other tools
echo -e "===============================================\n"
echo -e "Installing other tools\n"
echo -e "===============================================\n"
sudo apt install gimp krita obs-studio vlc geany dconf-editor


# installing Sublime text editor
echo -e "===============================================\n"
echo -e "Installing sublime-text-4\n"
echo -e "===============================================\n"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo -e "(Installing the stable branch)\n"
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text


# installing Virtual Box
# echo -e "===============================================\n"
# echo -e "Installing Virtual Box\n"
# echo -e "===============================================\n"
# sudo apt install virtualbox virtualbox-ext-pack


# Installing vim-plug for vim and neovim
echo -e "===============================================\n"
echo -e "Installing vim-plug for vim\n"
echo -e "===============================================\n"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo -e "===============================================\n"
echo -e "Installing vim-plug for neovim\n"
echo -e "===============================================\n"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


echo -e "===============================================\n"
echo -e "                      DONE                       "
echo -e "===============================================\n"





