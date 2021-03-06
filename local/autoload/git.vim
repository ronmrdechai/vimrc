" Return the path of file relative to the git root
function git#getpath(file)
    let l:cwd = getcwd()
    execute 'cd' fnamemodify(expand(a:file), ':p:h')
    let l:git_root = system('git rev-parse --show-toplevel')
    let l:git_root = substitute(l:git_root, '\n$', '', '')
    let l:path = substitute(fnamemodify(expand(a:file), ':p'),
                \fnameescape(l:git_root . '/'), '', '')
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
    wincmd p
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

" Stage changes added in the GitDiff window
function git#stage()
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
        call system('git cat-file -p HEAD:' . git#getpath('%') . ' > '
                    \. l:orig_buf_name)
        windo write
        call system('git diff ' . l:orig_buf_name . ' ' . l:diff_buf_name
                    \. ' > ' . l:tmp_patch_name)
        call system('sed -i "" "1,4d" ' . l:tmp_patch_name)
        call system('git diff ' . expand('%') . ' | head -n4 | cat - '
                    \. l:tmp_patch_name . ' > ' . l:patch_name)
        execute 'cd' fnameescape(l:cwd)
        Gdf
        execute 'G! apply --cached --recount' l:patch_name
    else
        echohl ErrorMsg
        echom 'Error: No diff buffer open'
        echohl None
    endif
endfunction

function git#cmd(bang, ...)
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

function git#set_branch()
    let l:cwd = getcwd()
    try
        cd %:p:h
    catch /^Vim\%((\a\+)\)\=:E/
        let b:git_branch = ""
        return
    endtry
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
