" This file contains Language Server configurations

if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

if executable('hh_client')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'hh_client',
        \ 'cmd': {server_info->['hh_client'], 'lsp'},
        \ 'whitelist': ['php'],
        \ })
endif

if executable('javascript-typescript-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'javascript-typescript-langserver',
        \ 'cmd': {server_info->['javascript-typescript-stdio']},
        \ 'whitelist': ['typescript'],
        \ })
endif

if executable('java') && filereadable(expand('~/Temp/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_*.jar'))
    au User lsp_setup call lsp#register_server({
            \ 'name': 'eclipse.jdt.ls',
            \ 'cmd': {server_info->[
            \     'java',
            \     '-Declipse.application=org.eclipse.jdt.ls.core.id1',
            \     '-Dosgi.bundles.defaultStartLevel=4',
            \     '-Declipse.product=org.eclipse.jdt.ls.core.product',
            \     '-Dlog.level=ALL',
            \     '-noverify',
            \     '-Dfile.encoding=UTF-8',
            \     '-Xmx1G',
            \     '-jar',
            \     expand('~/Temp/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_*.jar'),
            \     '-configuration',
            \     expand('~/Temp/eclipse.jdt.ls/config_mac'),
            \     '-data',
            \     '/tmp/eclipse.jdt.ls'
            \ ]},
            \ 'whitelist': ['java'],
            \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    nmap <buffer> <C-]> <plug>(lsp-definition)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> = <plug>(lsp-format-document)
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
