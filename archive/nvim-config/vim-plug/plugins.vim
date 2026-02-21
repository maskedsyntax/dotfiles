" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " File Explorer
    Plug 'scrooloose/NERDTree'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    "Onedark theme
    Plug 'joshdick/onedark.vim'
    Plug 'morhetz/gruvbox'
    Plug 'dracula/vim'
    Plug 'alessandroyorba/Alduin'
    Plug 'romainl/apprentice'
    "Autocompletion
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

    "For indentation
    "Plug 'thaerkh/vim-indentguides'
    Plug 'Yggdroot/indentLine'

    "Status Line
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'ryanoasis/vim-devicons'
    
    call plug#end()
