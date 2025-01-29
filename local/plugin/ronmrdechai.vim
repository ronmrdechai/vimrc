" ronmrdechai.vim - Personal functions by 
" Language:     N/A
" Maintainer:   Ron Mordechai <ronmrdechai@gmail.com>
" URL:          https://github.com/ronmrdechai/vimrc
"
" Copyright: (c) 2019, Ron Mordechai  All rights reserved.
"
" This source code is licensed under the BSD-style license found in the
" LICENSE file in the toplevel directory of this source tree.  An additional
" grant of patent rights can be found in the PATENTS file in the same
" directory.

if exists("g:loaded_ronmrdechai")
  finish
endif
let g:loaded_ronmrdechai = 1

if !exists("g:ronmrdechai#fbhome")
  let g:ronmrdechai#fbhome = expand('~')
endif

function! ronmrdechai#biggrep(preview, ...)
  let file_path = expand('%:p:h')

  let repo_abbrev = 'z'
  if file_path =~# 'configerator'
    let repo_abbrev = 'c'
  elseif file_path =~# 'www'
    let repo_abbrev = 't'
  elseif file_path =~# 'fbcode'
    let repo_abbrev = 'f'
  elseif file_path =~# 'fbandroid'
    let repo_abbrev = 'a'
  elseif file_path =~# 'opsfiles'
    let repo_abbrev = 'o'
  endif

  let color_arg = '--color=on '
  if has("macunix")
    let color_arg = ''
  endif

  let argstring = len(a:000) == 0 ? 
        \ input(toupper(repo_abbrev) . 'bgs: ') : shellescape(join(a:000, ' '))
  let command = repo_abbrev . 'bgs ' . color_arg . argstring .
        \ '| sed "s,^[^/]*/,," | sed "s#^#$(hg root)/#g"'
  let preview = a:preview ?
        \ fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('up:55%:hidden', '?')
  call fzf#vim#grep(command, 1, preview, a:preview)
endfunction

function! ronmrdechai#diffusionlink(file, line1, line2)
  let repo_path = systemlist('hg root')[0]
  if v:shell_error != 0
    echoerr 'Not in Mercurial repository'
    return
  endif

  let repo_abbrev = 'FBS'
  if repo_path =~# 'configerator'
    let repo_abbrev = 'CF'
  elseif repo_path =~# 'www'
    let repo_abbrev = 'WWW'
  elseif repo_path =~# 'opsfiles'
    let repo_abbrev = 'OPSFILES'
  endif
  
  let relpath = substitute(fnamemodify(a:file, ':p'), repo_path, '', '')
  return 'https://our.internmc.facebook.com/intern/diffusion/' . repo_abbrev .
        \ '/browse/master' . relpath . '?lines=' . a:line1 . '-' . a:line2
endfunction

command! -bang -nargs=* Biggrep call ronmrdechai#biggrep(<bang>0, <f-args>)
command! -range DiffusionLink
      \ echom ronmrdechai#diffusionlink(expand('%'), <line1>, <line2>)
command! -range OpenInDiffusion
      \ call system('open ' . ronmrdechai#diffusionlink(expand('%'), <line1>, <line2>))

nnoremap ,g :Biggrep<CR>
nnoremap ,,g :Biggrep <C-r><C-w><CR>

if has("macunix")
  nnoremap ,o :OpenInDiffusion<CR>
  vnoremap ,o :'<,'>OpenInDiffusion<CR>
else
  nnoremap ,o :DiffusionLink<CR>
  vnoremap ,o :'<,'>DiffusionLink<CR>
endif
