let b:start = executable('pry') ? 'pry -r "%:p"' : 'irb -r "%:p"'
if expand('%') =~# '_test\.rb$'
  let g:rspec_command = 'Dispatch ruby {spec}'
  let b:dispatch = 'ruby -W2 %'
elseif expand('%') =~# '_spec\.rb$'
  let b:dispatch = 'rspec %'
elseif !exists('b:dispatch')
  let b:dispatch = 'ruby %'
endif
