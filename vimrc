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
set wildignore+=*/build/*
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

" Use ripgrep/ag/ack for grepping when available
if executable('rg')
    set grepprg=rg\ --vimgrep
    let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
elseif executable('ag')
    set grepprg=ag\ --vimgrep
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
elseif executable('ack')
    set grepprg=ack\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
    let g:ctrlp_user_command = 'ack %s -l --nocolor -g ""'
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

" Make vim change the cursor when in insert mode in various terminals.
if $TERM_PROGRAM == "iTerm.app" || exists("$KONSOLE_DBUS_SERVICE")
    let &t_SI = TmuxEscape("\<Esc>]50;CursorShape=1\x7")
    let &t_EI = TmuxEscape("\<Esc>]50;CursorShape=0\x7")
    let &t_SR = TmuxEscape("\<Esc>]50;CursorShape=2\x7")
elseif $TERM_PROGRAM == "Apple_Terminal" || $COLORTERM == "gnome-terminal"
    let &t_SI = TmuxEscape("\<Esc>[5 q")
    let &t_EI = TmuxEscape("\<Esc>[0 q")
    let &t_SR = TmuxEscape("\<Esc>[4 q")
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

" If tmux is running, activate focus events and save on focus lost
if exists("$TMUX")
    let &t_ti .= "\<Esc>[?1004h"
    let &t_te .= "\<Esc>[?1004l"

    nnoremap <silent><special> <Esc>[O :silent doautocmd FocusLost %<CR>
    nnoremap <silent><special> <Esc>[I :silent doautocmd FocusGained %<CR>
    onoremap <silent><special> <Esc>[O <Esc>:silent doautocmd FocusLost %<CR>
    onoremap <silent><special> <Esc>[I <Esc>:silent doautocmd FocusGained %<CR>
    vnoremap <silent><special> <Esc>[O <Esc>:silent doautocmd FocusLost %<CR>gv
    vnoremap <silent><special> <Esc>[I <Esc>:silent doautocmd FocusGained %<CR>gv
    inoremap <silent><special> <Esc>[O <C-O>:silent doautocmd FocusLost %<CR>
    inoremap <silent><special> <Esc>[I <C-O>:silent doautocmd FocusGained %<CR>

    au FocusLost * silent! wa
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
nmap ZW :wa<Bar>q<CR>
nmap Y y$

" Readline-like command-line mode
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>

" Next and previous buffers, locations, and quickfix
for letter in ["b", "c", "l", "t"]
    exe printf("nmap <silent>]%s :%snext<CR>", letter, letter)
    exe printf("nmap <silent>]%s :%slast<CR>", toupper(letter), letter)
    exe printf("nmap <silent>[%s :%sprevious<CR>", letter, letter)
    exe printf("nmap <silent>[%s :%sfirst<CR>", toupper(letter), letter)
endfor
nmap ]a :next<CR>
nmap ]A :last<CR>
nmap [a :previous<CR>
nmap [A :first<CR>

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

" Toggle paste mode with <leader>p
nnoremap <leader>p :set paste! paste?<CR>

" Toggle spell mode with <leader>s
nnoremap <leader>s :set spell! spell?<CR>

" Stop highlighting things with <leader>h
nnoremap <leader>h :nohlsearch<CR>

" Search with vimgrep
nnoremap <leader>g :vim  **/*.%:e<C-b><Right><Right><Right><Right>

" Map function keys to <leader>#
let i=0
while i<=9
    exe printf('nmap <leader>%d <F%d>', i, i)
    let i+=1
endwhile
let i=0
while i<=6
    exe printf('nmap <leader><leader>%d <F1%d>', i, i)
    let i+=1
endwhile

" Options for perl
autocmd FileType perl
            \ setlocal complete-=i |
            \ setlocal makeprg=perl\ -c\ -MVi::QuickFix\ % |
            \ setlocal errorformat+=%m\ at\ %f\ line\ %l\. |
            \ setlocal errorformat+=%m\ at\ %f\ line\ %l

" Options for python
autocmd FileType python
            \ setlocal makeprg=pep8\ % |
            \ setlocal completeopt-=preview

" Poor man's a.vim
autocmd FileType cpp
            \ cabbrev <buffer> `c %:r.cc |
            \ cabbrev <buffer> `h %:r.h
autocmd FileType c
            \ cabbrev <buffer> `c %:r.c |
            \ cabbrev <buffer> `h %:r.h

" Spell check for git commit messages and markdown
autocmd FileType gitcommit setlocal spell
autocmd FileType markdown  setlocal spell

" Use ~/.vim/local for local plugins
let &rtp .= ',~/.vim/local/'

" Enable syntax highlighting
filetype plugin indent on
syntax on

" Set the colorscheme
set background=dark
let g:gruvbox_italic=0
colorscheme gruvbox

" CtrlP options
let g:ctrlp_extensions = ['tag']

" Write to file as root with "WRITE"
command WRITE %!sudo tee > /dev/null %

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
    execute "!" . l:exe . " -R --c++-kinds=+p --fields=+iaS --extra=+q --exclude=*.txt" . l:dir
endfunction
command -nargs=? GenerateTags call GenerateTags(<f-args>)
map <F10> :GenerateTags<CR>

" Basic template support
augroup templates
  au!
  " Read in template files
  autocmd BufNewFile *.* silent! execute "0r $HOME/.vim/skel/" . tolower(expand("<afile>:e"))

  " Parse special text in the templates after the read
  autocmd BufNewFile * silent %substitute#\[:VIM_EVAL:\]\(.\{-\}\)\[:END_EVAL:\]#\=eval(submatch(1))#ge | execute "normal gg"
augroup END
