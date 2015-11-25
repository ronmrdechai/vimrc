" Disable vi compatibility
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

" Statusbar options
set showcmd
set laststatus=2
set statusline=%<%n:%f\ %h%m%r%y%=%-25.(%{b:git_branch}\ \ \ %l/%L\ %c%V%)\ %P

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
if !isdirectory(&undodir)
    silent call mkdir(&undodir, "p")
endif

" Move viminfo into .vim
set viminfo+=n$HOME/.vim/viminfo

" Use ag/ack for grepping when available
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('ack')
    set grepprg=ack\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

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

" Make vim change the cursor when in insert mode in iTerm2 and Konsole
if $TERM_PROGRAM == "iTerm.app" || exists("$KONSOLE_DBUS_SERVICE")
    let &t_SI = TmuxEscape("\<Esc>]50;CursorShape=1\x7")
    let &t_EI = TmuxEscape("\<Esc>]50;CursorShape=0\x7")
endif

" TODO: Find a better condition for this
if has('unix')
    " Enable bracketed paste mode when entering vim
    let &t_ti .= "\<Esc>[?2004h"
    let &t_te .= "\<Esc>[?2004l"
    function PasteStart(ret)
        set pastetoggle=<Esc>[201~
        set paste
        return a:ret
    endfunction
    " ':set paste' automatically when pasting
    inoremap <special><expr><Esc>[200~ PasteStart("")
    noremap  <special><expr><Esc>[200~ PasteStart("0i")
    cnoremap <special><expr><Esc>[200~ ""
    cnoremap <special><expr><Esc>[201~ ""
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

" Readline-like command-line mode
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>

" Next and previous buffers, locations, and quickfix
nmap <silent>]l :lnext<CR>
nmap <silent>[l :lprevious<CR>
nmap <silent>]c :cnext<CR>
nmap <silent>[c :cprevious<CR>
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

" Poor man's CtrlP
set path=.,**
set wildcharm=<C-z>
nnoremap gb :ls<CR>:b<Space>
nnoremap <leader>f :find *
nnoremap <leader>s :vert sfind *
nnoremap <leader>F :find <C-R>=expand('%:h').'/*'<CR>
nnoremap <leader>S :vert sfind <C-R>=expand('%:h').'/*'<CR>
nnoremap <leader>u :buffer <C-z><S-Tab>
nnoremap <leader>U :vert sbuffer <C-z><S-Tab>

" Execute current line or selected lines
command -bar -range Execute silent <line1>,<line2>yank z
            \ | let @z = substitute(@z, '\n\s*\\', '', 'g') | @z
nnoremap <silent>g!! :Execute<Bar>execute 'normal! ' . v:count1 . 'j'<CR>
xnoremap <silent>g!  :Execute<Bar>execute 'normal! ' . v:count1 . 'j'<CR>

" Toggle paste mode with <leader>p
nnoremap <leader>p :set invpaste paste?<CR>

" Map function keys to <leader>#
let i=0
while i<=9
    exe printf('nmap <leader>%d <F%d>', i, i)
    let i+=1
endwhile
let i=0
while i<=6
    exe printf('nmap <leader><leader>%d <F%d>', i, i)
    let i+=1
endwhile

" Open files with specific syntax
autocmd BufRead,BufNewFile *.asm set filetype=nasm

" Tame keyword completion in Perl
autocmd FileType perl setlocal complete-=i

" Spell check for git commit messages
autocmd FileType gitcommit setlocal spell

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
Plug  'vim-scripts/avr.vim'
Plug      'morhetz/gruvbox'
Plug        'wting/rust.vim'
Plug   'scrooloose/syntastic'
Plug    'godlygeek/tabular',        { 'on': 'Tabularize' }
Plug 'Keithbsmiley/tmux.vim'
Plug        'tpope/vim-commentary'
Plug       'rodjek/vim-puppet'
Plug        'tpope/vim-surround'
call plug#end()

" And use ~/.vim/local for local plugins
let &rtp .= ',~/.vim/local/'

" Enable syntax highlighting
filetype plugin indent on
syntax on

" Set the colorscheme
set background=dark
let g:gruvbox_italic=0
colorscheme gruvbox

" Syntastic
let g:syntastic_always_populate_loc_list = 1

" Write to file as root with "WRITE"
command WRITE %!sudo tee > /dev/null %

" Call '!git' more easily
function CmdGit(bang, ...)
    let l:env = "env GIT_EDITOR=true GIT_PAGER=cat "
    let l:cwd = getcwd()
    cd %:p:h
    let l:res = system(l:env . "git " . join(a:000, " ") .
                \ (a:bang ? "" : " " . expand("%:t")))
    if l:res != ""
        echo l:res
    endif
    edit!
    execute 'cd' fnameescape(l:cwd)
endfunction

command -nargs=* -bang G   call CmdGit(<bang>0, <f-args>)
command -nargs=* -bang Git call CmdGit(<bang>0, <f-args>)

" Set b:git_branch to the current git branch
function SetGitBranch()
    let l:cwd = getcwd()
    cd %:p:h
    let l:branch = system("git rev-parse --abbrev-ref HEAD 2> /dev/null")
    if v:shell_error
        let l:branch = ""
    endif
    let l:branch = substitute(l:branch, '\n$', '\1', '')
    if l:branch == "HEAD"
        let l:branch = system("git rev-parse --short HEAD 2> /dev/null")
        let l:branch = substitute(l:branch, '\n$', '\1', '')
    endif
    execute 'cd' fnameescape(l:cwd)
    let b:git_branch = l:branch
endfunction
autocmd BufEnter * call SetGitBranch()

" Generate tags for specified directory
function GenerateTags(...)
    if a:0 == 0
        let l:dir = '.'
    else
        let l:dir = a:1
    endif
    if executable("exctags")
        let l:exe = "exctags"
    else
        let l:exe = "ctags"
    endif
    execute "!" . l:exe . " -R --c++-kinds=+p --fields=+iaS --extra=+q " . l:dir
endfunction
command -nargs=? GenerateTags call GenerateTags(<f-args>)
map <F10> :GenerateTags<CR>
