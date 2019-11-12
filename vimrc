" This file contains configuration for both Vim and IdeaVim.

" Tab options
set expandtab
set smarttab
set shiftwidth=2
set tabstop=8

" Make backspace work properly
set backspace=indent,eol,start
" Statusbar options set showcmd
set laststatus=2
set statusline=%<%n:%f\ %h%m%r%y%=%-15.(%l/%L\ %c%V%)\ %P

" Better searching
set hlsearch
set incsearch

" Better line joining
set formatoptions+=j

" Show line numbers
set number

" Show matching brackets
set showmatch
set matchpairs+=<:>

" Hide closed buffers
set hidden

" Set a dictionary for dictionary completion
set dictionary=/usr/share/dict/words

" Better command completion
set wildmenu
set wildignorecase

" Better casing
set ignorecase
set smartcase

" Set <leader> to space, it's much easier to mash this way
let mapleader=" "

" Fix Y
nmap Y y$

" Readline-like command-line mode
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>

" Allow moving lines up or down with Ctrl-<Up>/<Down>
nnoremap <silent><C-j> :m .+1<CR>==
nnoremap <silent><C-k> :m .-2<CR>==
inoremap <silent><C-j> <Esc>:m .+1<CR>==gi
inoremap <silent><C-k> <Esc>:m .-2<CR>==gi
vnoremap <silent><C-j> :m '>+1<CR>gv=gv
vnoremap <silent><C-k> :m '<-2<CR>gv=gv

" IdeaVim cannot parse this line:
exe "source ~/.vim/vimonly.vim"
