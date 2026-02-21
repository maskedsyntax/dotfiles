#!/bin/bash

sudo dnf update && sudo dnf upgrade

# Enabling the RPM Fusion repos
# For better availability of apps

echo -e "================================================================\n"
echo -e "Enabling the RPM Fusion repos for better availability of apps"
echo -e "================================================================\n"

# To enable Free Repos

echo -e "================================================================\n"
echo -e "To enable Free Repos"
echo -e "================================================================\n"
sudo dnf install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

# To enable Non-free Repos

echo -e "================================================================\n"
echo -e "To enable Non-free Repos"
echo -e "================================================================\n"
sudo dnf install \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


sudo dnf update

# Installing the multimedia libraries

echo -e "================================================================\n"
echo -e "Installing the multimedia libraries"
echo -e "================================================================\n"
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install lame\* --exclude=lame-devel
sudo dnf group upgrade --with-optional Multimedia



# Installing essential apps
echo -e "===============================================\n"
echo -e "Installing the following apps: \n1. Vim\n2. Neovim\n3. xsel(Clipboard for vim & neovim)\n4. nodejs\n5. npm\n6. yarn\n7. zsh\n8. tree\n9. tmux\n"
echo -e "===============================================\n"
sudo dnf install htop 


# Installing essential apps
echo -e "===============================================\n"
echo -e "Installing the following apps: Github-Desktop"
echo -e "===============================================\n"
sudo wget https://github.com/shiftkey/desktop/releases/download/release-3.0.2-linux1/GitHubDesktop-linux-3.0.2-linux1.rpm

