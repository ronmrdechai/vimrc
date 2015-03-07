" Return the path of file relative to the git root
function git#getpath(file)
    let l:cwd = getcwd()
    execute 'cd' fnamemodify(expand(a:file), ':p:h')
    let l:git_root = system('git rev-parse --show-toplevel')
    let l:git_root = substitute(l:git_root, '\n$', '', '')
    let l:path = substitute(expand(a:file), fnameescape(l:git_root . '/'), '', '')
    execute 'cd' fnameescape(l:cwd)
    return l:path
endfunction

" Show changes in git
function git#diff()
    let l:cwd = getcwd()
    let l:cur = getpos('.')
    let l:winview = winsaveview()
    let l:path = git#getpath('%:p')
    let l:ft = &ft
    cd %:p:h
    if filereadable("/tmp/" . expand("%:t") . ".diff")
        call delete("/tmp/" . expand("%:t") . ".diff")
    endif
    diffthis
    silent! vnew /tmp/%:t.diff
    let l:bufnum = bufnr('%')
    execute '.!git cat-file -p HEAD:' . l:path
    diffthis
    let &ft=l:ft
    set nomodified
    normal zR
    call setpos('.', l:cur)
    call winrestview(l:winview)
    execute 'cd' fnameescape(l:cwd)
    return l:bufnum
endfunction

" Toggle the GitDiff split
function git#togglediff()
    if exists('b:git_diff_buf')
        execute 'bdelete!' b:git_diff_buf
        unlet b:git_diff_buf
    else
       let b:git_diff_buf = git#diff()
    endif
endfunction

" Commit changes added in the GitDiff window
function git#commit()
    if exists('b:git_diff_buf')
        let l:cwd = getcwd()
        cd %:p:h
        let l:diff_buf_name = bufname(b:git_diff_buf)
        let l:orig_buf_name = "/tmp/" . expand("%:t") . ".orig"
        let l:patch_name = "/tmp/" . expand("%:t") . ".patch"
        let l:tmp_patch_name = "/tmp/" . expand("%:t") . ".patch_tmp"
        if filereadable(l:orig_buf_name)
            call delete(l:orig_buf_name)
        endif
        let l:git_root = system('git rev-parse --show-toplevel')
        let l:git_root = substitute(l:git_root, '\n$', '', '')
        call system('git cat-file -p HEAD:' . git#getpath('%') . ' > ' . l:orig_buf_name)
        windo write
        call system('git diff ' . l:orig_buf_name . ' ' . l:diff_buf_name . ' > ' . l:tmp_patch_name)
        call system('sed -i "" "1,4d" ' . l:tmp_patch_name)
        call system('git diff ' . expand('%') . ' | head -n4 | cat - ' . l:tmp_patch_name . ' > ' . l:patch_name)
        execute 'cd' fnameescape(l:cwd)
        Gdf
        execute 'G! apply --cached --recount' l:patch_name
    else
        echoerr 'No diff buffer open'
    endif
endfunction
