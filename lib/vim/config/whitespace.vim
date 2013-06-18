set list
set listchars=tab:⇁•,trail:•,extends:#,nbsp:•

autocmd BufWritePre * :call <SID>StripTrailingWhitespace()

function! <SID>StripTrailingWhitespace()
  " Don't strip any spaces when the filetype is markdown
  if &ft =~ 'markdown'
    return
  endif
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
