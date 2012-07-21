"call pathogen#runtime_append_all_bundles()
"call pathogen#helptags()

filetype off " Turn off _before_ loading all Bundles

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" Let Vundle manage Vundle (required)!
Bundle 'gmarik/vundle'
" My bundles
Bundle 'ervandew/supertab'
Bundle 'kchmck/vim-coffee-script'
Bundle 'kien/ctrlp.vim'
Bundle 'leshill/vim-json'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-rvm'
Bundle 'tpope/vim-surround'
Bundle 'vim-ruby/vim-ruby'
Bundle 'vim-scripts/bufkill.vim'

filetype plugin indent on " Turn on _after_ loading all Bundles

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

set encoding=utf-8
set backupdir=~/.vim/tmp
set directory=~/.vim/tmp        " Don't clutter up dirs with swp and tmp files
set history=500		        " keep 500 lines of command line history
set autoread                    " reload files only changed outside vim from disk

set ttyfast                     " u got a fast terminal

set nocompatible                " We're running VIM, not vi
set mouse=a                     " allow ... mouse ...

set ruler		        " show the cursor position all the time
set relativenumber              " show line numbers relative to cursor
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set showcmd		        " display incomplete commands
set showmatch
set wmh=0                       " minimum unfocussed window height
set viminfo+=!

set guifont=Triskweline_10:h10
set guioptions-=T
set hlsearch                    " highlight matches
set incsearch                   " incremental searching

set shiftwidth=2
set expandtab
set smarttab
set colorcolumn=80              " mark the 80th character
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter
set scrolloff=5                 " don't show search results as the first line
set laststatus=2                " Always show status line.
set autoindent                  " always set autoindenting on
set shiftround                  " When at 3 spaces and I hit >>, go to 4, not 5.

set gdefault                    " assume the /g flag on :s
set tags=./tags;                " Set the tag file search order
set grepprg=ack                 " Use Ack instead of grep
" set iskeyword-=_               " Use _ as a word-separator
set wildmenu                    " Better? completion on command line
set wildmode=list:longest,full
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" ================
" Ruby stuff
" ================
augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType ruby,eruby,yaml set ai sw=2 sts=2 et
augroup END
" ================

" Format xml files
autocmd FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"
" Don't add the comment prefix when I hit enter or o/O on a comment line.
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" When loading text files, wrap them and don't split up words.
autocmd BufNewFile,BufRead *.txt setlocal wrap
autocmd BufNewFile,BufRead *.txt setlocal lbr
" Set up some useful Rails.vim bindings for working with Backbone.js
autocmd User Rails Rnavcommand template    app/assets/templates               -glob=**/*  -suffix=.jst.ejs
autocmd User Rails Rnavcommand jmodel      app/assets/javascripts/models      -glob=**/*  -suffix=.coffee
autocmd User Rails Rnavcommand jview       app/assets/javascripts/views       -glob=**/*  -suffix=.coffee
autocmd User Rails Rnavcommand jcollection app/assets/javascripts/collections -glob=**/*  -suffix=.coffee
autocmd User Rails Rnavcommand jrouter     app/assets/javascripts/routers     -glob=**/*  -suffix=.coffee
autocmd User Rails Rnavcommand jspec       spec/javascripts                   -glob=**/*  -suffix=.coffee
" Fix some performance issues
autocmd BufWinLeave * call clearmatches()

imap § <esc>

" ====================
" CtrlP options
" :help ctrlp-commands
" ====================
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_switch_buffer = 2
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$|^vendor$|^coverage$|^tmp$|^rdoc$|',
  \ 'file': '\.png$\|\.jpg$\|\.gif$|',
  \ }
" \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
let g:ctrlp_max_depth = 10      " Directory depth to recurse into when scanning
let g:ctrlp_open_new_file = 't' " open files in new tab

let mapleader = ","

" Quick open some default locations
nmap <Leader>bi :source ~/.vimrc<cr>:BundleInstall<cr>
nmap <Leader>bx :tabe ~/Dropbox<cr>
nmap <Leader>sn :tabe ~/.vim/snippets/ruby.snippets<CR>
nmap <Leader>vi :tabe ~/.vimrc<CR>

nmap <Leader>f :sp spec/fabricators<CR>
nmap <Leader>fa :sp test/factories.rb<CR>
nmap <Leader>sc :sp db/schema.rb<cr>

" vim-fugitive
map <Leader>bl :Gblame<CR>
nmap <Leader>gac :Gcommit -m -a ""<LEFT>
nmap <Leader>gc :Gcommit -m ""<LEFT>
nmap <Leader>gs :Gstatus<CR>

" Ctrl-P 
nmap <Leader>h :CtrlP<CR>
nmap <Leader>rf :CtrlPClearCache<CR>

" Quick insert stuff
nmap <Leader>p osave_and_open_page=h
nmap <Leader>d obinding.pry<cr>

" Edit another file in the same directory as the current file
" uses expression to extract path from current file's path
nmap <Leader>e :e <C-R>=expand("%:p:h") . '/'<CR>
nmap <Leader>s :split <C-R>=expand("%:p:h") . '/'<CR>
nmap <Leader>v :vnew <C-R>=expand("%:p:h") . '/'<CR>
" Merge a tab into a split in the previous window
nmap <c-w>u :call MergeTabs()<CR>

map <c-h> :set hlsearch!<cr>
imap <c-l> :<space>
map <c-s> <esc>:w<cr>
imap <c-s> <esc>:w<cr>
map <c-t> <esc>:tabnew<cr>
" map <c-x> <c-w>c
map <c-n> :cn<cr>
map <c-p> :cp<cr>

" Emacs-like beginning and end of line.
imap <c-e> <c-o>$
imap <c-a> <c-o>^
" Disable Ex mode
map Q <Nop>
" Disable K looking stuff up
map K <Nop>
" Center search matches when jumping
map N Nzz
map n nzz

imap <Tab> <C-P>

" Skip buffer lines, not actual (wrapped) lines
nmap k gk
nmap j gj

noremap <F9> :set spell! spell?<CR>

command! Q q " Bind :Q to :q
command! Qall qall

runtime macros/matchit.vim
runtime! config/**/*.vim
