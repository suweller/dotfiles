" ====================
" CtrlP options
" :help ctrlp-commands
" ====================
nmap <LEADER>rf :CtrlPClearCache<CR>

let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_switch_buffer = 2
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$|^vendor$|^coverage$|^tmp$|^rdoc$|',
  \ 'file': '\.png$\|\.jpg$\|\.gif$|\.DS_Store',
  \ }
" \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_depth = 10      " Directory depth to recurse into when scanning
let g:ctrlp_open_new_file = 't' " open files in new tab
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files'],
    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
  \ },
  \ 'fallback': 'find %s -type f'
  \ }
