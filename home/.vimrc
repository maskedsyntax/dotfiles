let g:mapleader = "\<Space>"

syntax on
set number
set hidden
set nowrap
set noerrorbells
set encoding=utf-8
set pumheight=10
set fileencoding=utf-8
set ruler
set t_Co=256
set termguicolors
set background=dark
set cmdheight=1
set splitbelow
set splitright
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set smartindent
set autoindent
set laststatus=0
set incsearch
set scrolloff=6
set clipboard=unnamedplus
set formatoptions-=c
set formatoptions-=r
set formatoptions-=o
set noshowmode
set mouse=a

inoremap jk <Esc>
inoremap kj <Esc>

vnoremap < <gv
vnoremap > >gv

call plug#begin('~/.vim/plugged')

Plug 'joshdick/onedark.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tomasiser/vim-code-dark'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Language-specific syntax highlight
Plug 'bfrg/vim-cpp-modern'          " Modern C/C++
Plug 'vim-python/python-syntax'     " Better Python
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' } " Go ecosystem (disable extras if needed)
Plug 'pangloss/vim-javascript'      " JavaScript
Plug 'leafgarland/typescript-vim'   " TypeScript
Plug 'peitalin/vim-jsx-typescript'  " TSX/JSX

" LSPs
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'


call plug#end()

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Enable LSP features in vim-go
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'


" if (has("autocmd") && !has("gui_running"))
"   augroup colorset
"     autocmd!
"     let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
"     autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
"   augroup END
" endif

" Force consistent background when using gruvbox
autocmd ColorScheme gruvbox hi Normal       ctermbg=NONE guibg=NONE
autocmd ColorScheme gruvbox hi LineNr       ctermbg=NONE guibg=NONE
autocmd ColorScheme gruvbox hi SignColumn   ctermbg=NONE guibg=NONE
autocmd ColorScheme gruvbox hi EndOfBuffer  ctermbg=NONE guibg=NONE
autocmd ColorScheme gruvbox hi VertSplit    ctermbg=NONE guibg=NONE
autocmd ColorScheme gruvbox hi StatusLine   ctermbg=NONE guibg=NONE


if &term == "alacritty"        
  let &term = "xterm-256color"
endif

let g:airline#extensions#whitespace#enabled = 0

let g:codedark_transparent=1
let g:codedark_italics=1
colorscheme codedark

"let g:gruvbox_contrast_dark = 'hard'
"let g:gruvbox_transparent_bg = 1
"colorscheme gruvbox

