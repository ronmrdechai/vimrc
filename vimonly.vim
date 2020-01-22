" This file includes configuration which is specific to Vim only. Include this
" file at the end of the `vimrc'.

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
  set colorcolumn=81,101
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
if exists("&t_SI") && exists("&t_EI") && exists("&t_SR")
  if exists("$ITERM_SESSION_ID") || exists("$KONSOLE_DBUS_SERVICE")
    let &t_SI = TmuxEscape("\<Esc>]50;CursorShape=1\x7")
    let &t_EI = TmuxEscape("\<Esc>]50;CursorShape=0\x7")
    let &t_SR = TmuxEscape("\<Esc>]50;CursorShape=2\x7")
  elseif $TERM_PROGRAM == "Apple_Terminal" || $COLORTERM == "gnome-terminal"
    let &t_SI = TmuxEscape("\<Esc>[5 q")
    let &t_EI = TmuxEscape("\<Esc>[0 q")
    let &t_SR = TmuxEscape("\<Esc>[4 q")
  endif
endif

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

" Toggle stuff
nnoremap <leader>p :set paste! paste?<CR>
nnoremap <leader>s :set spell! spell?<CR>

" Stop highlighting
nnoremap <leader>h :nohlsearch<CR>

" Show TODO list
nnoremap <leader>t :vim TODO %<CR>

" FZF
nnoremap ,f :Files<CR>
nnoremap ,g :GFiles<CR>
nnoremap ,b :Buffers<CR>
nnoremap ,m :Marks<CR>
nnoremap ,r :Rg<CR>
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

" Easy align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

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

" Options for php
autocmd FileType php
      \ let hack#enabled = 0 |
      \ nmap <silent><C-]> :HackGotoDef<CR> |
      \ nmap <silent><leader>m :HackMake<CR> |
      \ nmap <silent><leader>t :HackType<CR>

" Python DSL file syntax highlighting
autocmd BufNewFile,BufRead BUCK setlocal filetype=bzl
autocmd BufNewFile,BufRead TARGETS setlocal filetype=bzl
autocmd BufNewFile,BufRead *.cinc setlocal filetype=python

" Run make with gm<letter>
nmap gmb :make<CR>
nmap gmc :make clean<CR>
nmap gmt :make test<CR>

" Open quickfix window after failed make
autocmd QuickFixCmdPost [^l]* cwindow

" Spell check for commit messages and documentation
autocmd FileType gitcommit setlocal spell
autocmd FileType hgcommit  setlocal spell
autocmd FileType markdown  setlocal spell
autocmd FileType text      setlocal spell

" Fix last mistake in insert mode
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Use ~/.vim/local for local plugins
set rtp+=$HOME/.vim/local/

" Enable syntax highlighting
filetype plugin indent on
syntax on

" Fix Java syntax
let java_highlight_java_lang_ids=1
let java_highlight_functions="style"
let java_javascript=1
let java_css=1
let java_vb=1

" Set the colorscheme
try
  set background=dark
  let g:gruvbox_italic=0
  colorscheme gruvbox
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme ron
endtry

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

source ~/.vim/lsp.vim
