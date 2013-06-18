"-- Files & Directories ---------------------------------------------------
" Remember things when we exit
"           +-> marks for up to # previously edited files
"           |   +-> Global marks
"           |   |  +-> Save up to # lines for each register
"           |   |  |    +-> # lines of command-line history
"           |   |  |    |   +-> # lines to save from the input line history
"           |   |  |    |   |   +-> # lines to save from the search history
"           |   |  |    |   |   |   +-> Disable 'hlsearch' highlights on start
"           |   |  |    |   |   |   | +-> Where to save the viminfo files
set viminfo='10,f1,<100,:20,@20,/20,h,n~/.vim/.viminfo

function! RestoreCursorPosition()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup restoreCursorPosition
  autocmd!
  autocmd BufWinEnter * call RestoreCursorPosition()
augroup END
