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
Bundle 'lmeijvogel/vim-yaml-helper'
Bundle 'nanotech/jellybeans.vim'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'nvie/vim-togglemouse'
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

" Switch syntax highlighting on, when the terminal has colors.
if &t_Co > 2 || has("gui_running")
  syntax on
endif
if &t_Co == 256 || has("gui_running")
  set t_Co=256
  colorscheme jellybeans
endif

filetype plugin indent on " Turn on _after_ loading all Bundles

set encoding=utf-8
set backupdir=~/.vim/tmp
set directory=~/.vim/tmp        " Don't clutter up dirs with swp and tmp files
set history=500                 " keep 500 lines of command line history
set autoread                    " reload files only changed outside vim from disk

set ttyfast                     " you got a fast terminal

set nocompatible                " We're running VIM, not vi
set mouse=a                     " allow ... mouse ...

set ruler                       " show the cursor position all the time
set relativenumber              " show line numbers relative to cursor
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set showcmd                     " display incomplete commands
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
set colorcolumn=80,115          " mark the 80th character, and github code window width
set smartcase                   " ... unless they contain at least one capital letter
set scrolloff=5                 " don't show search results as the first line
set laststatus=2                " Always show status line.
set autoindent                  " always set autoindenting on
set shiftround                  " When at 3 spaces and I hit >>, go to 4, not 5.

set gdefault                    " assume the /g flag on :s
" set tags=./tags;                " Set the tag file search order
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

imap § <ESC>

let mapleader = " "

" quick open some default locations
nmap <LEADER>bi :source ~/.vimrc<CR>:BundleInstall<CR>
nmap <LEADER>bx :tabe ~/Dropbox<CR>
nmap <LEADER>sn :tabe ~/.vim/snippets/ruby.snippets<CR>
nmap <LEADER>vi :tabe ~/.vimrc<CR>

nmap <LEADER>f :sp spec/fabricators<CR>
nmap <LEADER>fa :sp test/factories.rb<CR>
nmap <LEADER>sc :sp db/schema.rb<CR>

" vim-fugitive
map <LEADER>gb :Gblame<CR>
nmap <LEADER>gac :Gcommit -m -a ""<LEFT>
nmap <LEADER>gc :Gcommit -m ""<LEFT>
nmap <LEADER>gs :Gstatus<CR>

" quick insert/rewrite stuff
nmap <LEADER>pa osave_and_open_page # DEBUG<ESC>
nmap <LEADER>de obinding.pry # DEBUG<ESC>
nmap <LEADER>pu j^y$Oputs '<C-R>"' # DEBUG<ESC>
nmap <LEADER>rh oraise 'hell' # DEBUG<ESC>
nmap <LEADER>rw :%s/\s\+$//<CR>
nmap <LEADER>bo $F\|bdwi{ <ESC><S-J>A }<ESC>jdd
nmap <LEADER>bl $bdwa{<ESC><S-J>A }<ESC>jdd

nmap <LEADER>q :q<CR>
nmap <LEADER>Q :qal<CR>
nmap <LEADER>bn :bn<CR>
nmap <LEADER>n :bn<CR>

map <C-H> :noh<CR>
imap <C-L> :<SPACE>
map <C-S> <ESC>:w<CR>
imap <C-S> <ESC>:w<CR>
map <LEADER><LEADER> :w<CR>
map <C-T> <ESC>:tabnew<CR>
map <C-N> :cn<CR>
map <C-P> :cp<CR>
map <F9> :set spell! spell?<CR>

" Emacs-like beginning and end of line.
imap <C-E> <C-O>$
imap <C-A> <C-O>^
" Disable Ex mode
map Q <NOP>
" Disable K looking stuff up
map K <NOP>
" Center search matches when jumping
map N Nzz
map n nzz

command! Q q " Bind :Q to :q
command! Qall qall

runtime macros/matchit.vim
runtime! config/**/*.vim
