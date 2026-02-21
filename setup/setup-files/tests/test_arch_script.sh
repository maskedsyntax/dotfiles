#installing oh-my-zsh
echo -e "===============================================\n"
echo -e "Installing ohmyzsh\n"
echo -e "===============================================\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

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

# Moving .vimrc to ~/.config folder
echo -e "===============================================\n"
echo -e "Moving(Copying) .vimrc to ~/.config folder\n"
echo -e "===============================================\n"
cp ~/Dotfiles/.vimrc ~/.

# Moving nvim-config-new to ~/.config/nvim
echo -e "===============================================\n"
echo -e "Moving(Copying) nvim-config-new to ~/.config/nvim\n"
echo -e "===============================================\n"
cp -r ~/Dotfiles/nvim-config-new ~/.config/nvim

# Moving Jetbrains Font from Kitty folder to /usr/share/fonts/
echo -e "===============================================\n"
echo -e "Moving Jetbrains Font from Dotfiles/kitty/ folder to /usr/share/fonts/\n"
echo -e "sudo permissions will be reqd."
echo -e "===============================================\n"
sudo mv ~/Dotfiles/kitty/FiraCode /usr/share/fonts/

echo -e "===============================================\n"
echo -e "                      DONE                       "
echo -e "===============================================\n"
