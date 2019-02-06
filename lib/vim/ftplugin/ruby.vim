let b:start = executable('pry') ? 'pry -r "%:p"' : 'irb -r "%:p"'
if expand('%') =~# '_test\.rb$'
  let g:rspec_command = 'Dispatch ruby {spec}'
  let b:dispatch = 'ruby -W2 %'
elseif expand('%') =~# '_spec\.rb$'
  let b:dispatch = 'rspec %'
elseif !exists('b:dispatch')
  let b:dispatch = 'ruby %'
endif
nnoremap <buffer> <LEADER>ds :tabe db/schema.rb<CR>
nnoremap <buffer> <LEADER>dm :Sex db/migrate/<CR>GG
nnoremap <buffer> <LEADER>pa osave_and_open_page # DEBUG<ESC>
nnoremap <buffer> <LEADER>if O<ESC>O# frozen_string_literal: true<ESC>
nnoremap <buffer> <LEADER>de o(require('pry'); binding.pry) # DEBUG<ESC>
nnoremap <buffer> <LEADER>df ofail 'fast' # DEBUG<ESC>
nnoremap <buffer> <LEADER>pu j^y$Oputs '<C-R>"' # DEBUG<ESC>
nnoremap <buffer> <LEADER>bo $F\|bdwi{ <ESC><S-J>A }<ESC>jdd
nnoremap <buffer> <LEADER>bl $bdwa{<ESC><S-J>A }<ESC>jdd
