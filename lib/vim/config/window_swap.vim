function! MarkWindowSwap()
    " marked window number
    let g:markedWinNum = winnr()
    let g:markedBufNum = bufnr("%")
endfunction

function! DoWindowSwap()
    let curWinNum = winnr()
    let curBufNum = bufnr("%")
    " Switch focus to marked window
    exe g:markedWinNum . "wincmd w"

    " Load current buffer on marked window
    exe 'hide buf' curBufNum

    " Switch focus to current window
    exe curWinNum . "wincmd w"

    " Load marked buffer on current window
    exe 'hide buf' g:markedBufNum
endfunction

" nnoremap H :call MarkWindowSwap()<CR> <C-w>h :call DoWindowSwap()<CR>
" nnoremap J :call MarkWindowSwap()<CR> <C-w>j :call DoWindowSwap()<CR>
" nnoremap K :call MarkWindowSwap()<CR> <C-w>k :call DoWindowSwap()<CR>
" nnoremap L :call MarkWindowSwap()<CR> <C-w>l :call DoWindowSwap()<CR>
