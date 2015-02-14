" This file is not compatible with vi
set nocompatible

" Support multi-byte character encodings
set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,gb18030,latin1

" Tab options
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

" Folding settings
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=1

" Make backspace work properly
set backspace=indent,eol,start

" Echo command
set showcmd

" Better searching
set hlsearch
set incsearch

" Show relative line numbers in normal mode and disable them in insert mode
set number
set relativenumber
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

" Show matching brackets
set showmatch

" Enable the use of the mouse
set mouse=a

" Hide closed buffers
set hidden

" Set a dictionary for dictionary completion
set dictionary=/usr/share/dict/words

" Better command completion
set wildmenu
set wildignorecase
set ignorecase
set smartcase

" Make vim save the undo tree for each file
set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000
set undoreload=10000

" Move viminfo into .vim
set viminfo+=n$HOME/.vim/viminfo

" Use ag for grepping
set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column
set grepformat=%f:%l:%c:%m,%f:%l:%m

" Highlight the 81st column
if exists('+colorcolumn')
    set textwidth=80
    set colorcolumn=+1
    hi ColorColumn ctermbg=9
endif

" Make vim show the background properly in tmux
if exists("$TMUX")
    set t_ut=
endif

" Wrap escape sequences when in tmux
function TmuxEscape(string)
    if !exists("$TMUX")
        return a:string
    endif
    let tmux_start = "\<Esc>Ptmux;"
    let tmux_end   = "\<Esc>\\"
    return tmux_start
                \ . substitute(a:string, "\<Esc>", "\<Esc>\<Esc>", 'g')
                \ . tmux_end
endfunction

if system("uname -s") == "Darwin\n" && $TERM_PROGRAM == "iTerm.app"
    " Make vim change the cursor when in insert mode
    let &t_SI = TmuxEscape("\<Esc>]50;CursorShape=1\x7")
    let &t_EI = TmuxEscape("\<Esc>]50;CursorShape=0\x7")

    " Set paste automatically when pasting
    let &t_SI .= TmuxEscape("\<Esc>[?2004h")
    let &t_EI .= TmuxEscape("\<Esc>[?2004l")
    function PasteStart()
        set pastetoggle=<Esc>[201~
        set paste
        return ""
    endfunction
    inoremap <special><expr><Esc>[200~ PasteStart()
endif

" GUI options in case I feel like opening MacVim
if has('gui_running')
    " Better gui font
    silent! set guifont=Monospace:h10
    if &guifont != 'Monospace:h10'
        set guifont=Monaco:h10
    endif
    " Remove the scrollbar
    set guioptions-=r
    " Make the window bigger
    set lines=50 columns=90
    " And make it transparent
    set transparency=5
    " Quit MacVim app on exit if we're running on OS X
    if system("uname -s") == "Darwin\n"
        function TerminateOnLeave()
            let processes =
                \ split(system("ps aux | grep -E '(Mac)?[V]im.*-g'"), '\n')
            if len(processes) == 1
                macaction terminate:
            endif
        endfunction
        autocmd VimLeave * call TerminateOnLeave()
    endif
endif

" netrw options
let g:netrw_winsize = -28
let g:netrw_liststyle = 3
let g:netrw_sort_sequence = '[\/]$,*'
let g:netrw_browse_split = 4
let g:netrw_dirhistmax = 0
let g:netrw_banner = 0
map <silent><F2> :Lexplore<CR>

" Set <leader> to space, it's much easier to mash this way
let mapleader=" "

" General mappings
nmap ZA :qa<CR>

" Next and previous buffers and locations
nmap <silent>]l :lnext<CR>
nmap <silent>[l :lprevious<CR>
nmap <silent>]b :bnext<CR>
nmap <silent>[b :bprevious<CR>

" Allow moving lines up or down with Ctrl-<Up>/<Down>
nnoremap <silent><C-j> :m .+1<CR>==
nnoremap <silent><C-k> :m .-2<CR>==
inoremap <silent><C-j> <Esc>:m .+1<CR>==gi
inoremap <silent><C-k> <Esc>:m .-2<CR>==gi
vnoremap <silent><C-j> :m '>+1<CR>gv=gv
vnoremap <silent><C-k> :m '<-2<CR>gv=gv

" CamelCase motions:
nnoremap <silent><leader>w :<C-u>call
            \ search('\<\<Bar>\U\@<=\u\<Bar>\u\ze\%(\U\&\>\@!\)
            \\<Bar>\%$','W')<CR>
nnoremap <silent><leader>b :<C-u>call
            \ search('\<\<Bar>\U\@<=\u\<Bar>\u\ze\%(\U\&\>\@!\)
            \\<Bar>\%^','bW')<CR>
onoremap <silent><leader>w :<C-u>call
            \ search('\<\<Bar>\U\@<=\u\<Bar>\u\ze\%(\U\&\>\@!\)
            \\<Bar>\%$','W')<CR>
onoremap <silent><leader>b :<C-u>call
            \ search('\<\<Bar>\U\@<=\u\<Bar>\u\ze\%(\U\&\>\@!\)
            \\<Bar>\%^','bW')<CR>

" Quickly open/source the vimrc file
nmap <leader>ev :edit $MYVIMRC<CR>
nmap <leader>sv :source $MYVIMRC<CR>

" Execute current line or selected lines
command -bar -range Execute silent <line1>,<line2>yank z
            \ | let @z = substitute(@z, '\n\s*\\', '', 'g') | @z
nnoremap <silent><leader>ee :Execute<Bar>execute 'normal! ' . v:count1 . 'j'<CR>
xnoremap <silent><leader>e  :Execute<Bar>execute 'normal! ' . v:count1 . 'j'<CR>

" Toggle paste mode with <leader>p
nnoremap <leader>p :set invpaste paste?<CR>

" Write to file as root with "WRITE"
command WRITE :w !sudo tee > /dev/null %

" Map function keys to <leader>#
let i=0
while i<=9
    exe 'nmap <leader>' . i . ' <F' . i . '>'
    let i+=1
endwhile
let i=0
while i<=6
    exe 'nmap <leader><leader>' . i . ' <F1' . i . '>'
    let i+=1
endwhile

" Open files with specific syntax
autocmd BufRead,BufNewFile *.asm set filetype=nasm

" Tame keyword completion in Perl
autocmd FileType perl setlocal complete-=i

" Download VimPlug if it does not exist
if empty(glob("~/.vim/plugged/plug.vim"))
    silent !mkdir -p ~/.vim/plugged
    silent !curl -sfLo ~/.vim/plugged/plug.vim
                \ https://raw.github.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif
" Use VimPlug for external packages
runtime! plugged/plug.vim
call plug#begin('~/.vim/plugged')
Plug  'vim-scripts/applescript.vim'
Plug    'jiangmiao/auto-pairs'
Plug  'vim-scripts/avr.vim'
Plug         'kien/ctrlp.vim',      { 'on': 'CtrlP' }
Plug       'gentoo/gentoo-syntax'
Plug      'morhetz/gruvbox'
Plug        'wting/rust.vim'
Plug   'scrooloose/syntastic'
Plug    'godlygeek/tabular',        { 'on': 'Tabularize' }
Plug 'Keithbsmiley/tmux.vim'
Plug        'bling/vim-airline'
Plug        'tpope/vim-commentary'
Plug        'tpope/vim-fugitive'
Plug      'terryma/vim-multiple-cursors'
Plug       'rodjek/vim-puppet'
Plug        'mhinz/vim-signify'
Plug        'tpope/vim-surround'
call plug#end()

" Enable syntax highlighting
filetype plugin indent on
syntax on

" Set the colorscheme
set background=dark
let g:gruvbox_italic=0
colorscheme gruvbox

" Airline
set laststatus=2
let g:airline_powerline_fonts = 0
let g:airline_detect_whitespace = 0
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tagbar#enabled = 0
let g:airline_left_sep = ' '
let g:airline_left_alt_sep  = '|'
let g:airline_right_sep = ' '
let g:airline_right_alt_sep = '|'

" CtrlP
let g:ctrlp_map = '<C-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
" Map ctrl-p to CtrlP for VimPlug
map <C-p> :CtrlP<CR>

" Gundo
map <silent><F3> :GundoToggle<CR>

" Syntastic
let g:syntastic_always_populate_loc_list = 1

" Tabar
map <silent><F4> :TagbarToggle<CR>

" Generate tags for specified directory
function GenerateTags(...)
    if a:0 == 0
        let dir = '.'
    else
        let dir = a:1
    endif
    execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q " . dir
endfunction
command -nargs=* GenerateTags call GenerateTags(<f-args>)
map <F10> :GenerateTags<CR>

" Generate a hexdump of the current file or revert it
function Hexdump()
    if !exists('b:hexdump')
        let b:hexdump = 0
    endif
    if b:hexdump == 1
        set nobinary
        set eol
        let b:hexdump = 0
        execute "%!xxd -r"
    else
        set binary
        set noeol
        let b:hexdump = 1
        execute "%!xxd"
    endif
endfunction
command Hexdump call Hexdump()
map <F9> :Hexdump<CR>

