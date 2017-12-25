command -nargs=* -bang G   call git#cmd(<bang>0, <f-args>)
command -nargs=* -bang Git call git#cmd(<bang>0, <f-args>)
command Gdf                call git#togglediff()
command GitDiff            call git#togglediff()
command Gad                call git#stage()
command GitAdd             call git#stage()

autocmd BufEnter * call git#set_branch()

nmap gGa :Gad<CR>
nmap gGd :Gdf<CR>
nmap gGo :G co<CR>
nmap gGr :G reset<CR>
nmap gGc :G ci -m ""<Left><CR>
