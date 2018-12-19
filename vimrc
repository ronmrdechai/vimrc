" Tab options
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

" Make backspace work properly
set backspace=indent,eol,start
" Statusbar options set showcmd
set laststatus=2
set statusline=%<%n:%f\ %h%m%r%y%=%-25.(%{b:git_branch}\ \ \ %l/%L\ %c%V%)\ %P

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

" Highlight the 81st column
if exists('+colorcolumn')
    set colorcolumn=81
    set formatoptions-=tc
    hi ColorColumn ctermbg=9
endif

" Make vim show the background properly in tmux
set t_ut=

" Wrap escape sequences when in tmux
function TmuxEscape(string)
    if !(exists("$TMUX") || $TERM == "screen-256color")
        return a:string
    endif
    let tmux_start = "\<Esc>Ptmux;"
    let tmux_end   = "\<Esc>\\"
    return tmux_start
                \ . substitute(a:string, "\<Esc>", "\<Esc>\<Esc>", 'g')
                \ . tmux_end
endfunction

" Make vim change the cursor when in insert mode in various terminals.
if exists("$ITERM_SESSION_ID") || exists("$KONSOLE_DBUS_SERVICE")
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
    let &t_ti .= TmuxEscape("\<Esc>[?2004h")
    let &t_te .= TmuxEscape("\<Esc>[?2004l")
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
if exists("$TMUX") || $TERM == "screen-256color"
    let &t_ti .= TmuxEscape("\<Esc>[?1004h")
    let &t_te .= TmuxEscape("\<Esc>[?1004l")

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

" Toggle stuff
nnoremap <leader>p :set paste! paste?<CR>
nnoremap <leader>s :set spell! spell?<CR>

" Stop highlighting
nnoremap <leader>h :nohlsearch<CR>

" FZF
nnoremap ,f :Files<CR>
nnoremap ,g :GFiles<CR>
nnoremap ,b :Buffers<CR>
nnoremap ,m :Marks<CR>
nnoremap ,a :Ag<CR>
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

if has("macunix")
    set rtp+=/Users/ronmrdechai/.homebrew/opt/fzf
elseif isdirectory(expand("$HOME/pkg"))
    set rtp+=$HOME/pkg/share/fzf
elseif isdirectory(expand("$HOME/.fzf"))
    set rtp+=$HOME/.fzf
endif

let g:fzf_history_dir = '$HOME/.local/share/fzf-history'
let g:fzf_buffers_jump = 1
let g:fzf_layout = { 'window': 'belowright 10split enew' }
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" cscope
set cscopetag
nnoremap <leader>ch :cscope h<CR>
for letter in ['a', 'c', 'd', 'e', 'f', 'g', 'i', 's', 't']
    exe printf('nnoremap <leader>c%s :cs find %s <C-r>=expand("<cword>")<CR><CR>',
                \ letter,
                \ letter)
endfor

" Easy align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

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

" Options for c and cpp
autocmd FileType c,cpp
            \ setlocal complete-=i |
            \ cabbrev <buffer> `c %:r.cc |
            \ cabbrev <buffer> `h %:r.h  |
            \ if executable("cc-build") |
            \     set makeprg=cc-build  |
            \ endif

" Run make with gm<letter>
nmap gmb :make<CR>
nmap gmc :make clean<CR>
nmap gmt :make test<CR>

" Open quickfix window after failed make
autocmd QuickFixCmdPost [^l]* cwindow

" Spell check for git commit messages and markdown
autocmd FileType gitcommit setlocal spell
autocmd FileType hgcommit  setlocal spell
autocmd FileType markdown  setlocal spell

" Use ~/.vim/local for local plugins
set rtp+=$HOME/.vim/local/

" Enable syntax highlighting
filetype plugin indent on
syntax on

" Set the colorscheme
set background=dark
let g:gruvbox_italic=0
colorscheme gruvbox

" Write to file as root with "WRITE"
command WRITE %!sudo tee > /dev/null %

" Basic template support
augroup templates
  au!
  " Read in template files
  autocmd BufNewFile *.* silent! execute "0r $HOME/.vim/skel/" . tolower(expand("<afile>:e"))

  " Parse special text in the templates after the read
  autocmd BufNewFile * silent %substitute#\[:VIM_EVAL:\]\(.\{-\}\)\[:END_EVAL:\]#\=eval(submatch(1))#ge | execute "normal gg"
augroup END
