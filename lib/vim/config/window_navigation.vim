" Edit another file in the same directory as the current file
" uses expression to extract path from current file's path
nmap <LEADER>e :e <C-R>=expand("%:p:h") . '/'<CR>
" nmap <LEADER>s :split <C-R>=expand("%:p:h") . '/'<CR>
nmap <LEADER>v :vnew <C-R>=expand("%:p:h") . '/'<CR>
" Merge a tab into a split in the previous window
nmap <C-W>u :call MergeTabs()<CR>

" switch between paste and regular insert mode
set pastetoggle=<F2>
