alias aliases="cd ~/.dotfiles && \$EDITOR ${0:a} && source ${0:a}; popd # aliases"
alias xsv="qsv"
alias zshrc='cd ~/.dotfiles && $EDITOR lib/config/zsh/.zshrc && source lib/config/zsh/.zshrc; popd # zshrc'
alias vimrc='cd ~/.dotfiles && $EDITOR lib/config/vim/vimrc; popd # vimrc'
alias tmuxrc='cd ~/.dotfiles && $EDITOR lib/config/tmux/tmux.conf && tmux source-file lib/config/tmux/tmux.conf; popd # tmuxrc'
alias gitrc='cd ~/.dotfiles && $EDITOR --cmd "set filetype=gitconfig" lib/gitconfig; popd # gitrc'
alias gems='$EDITOR ~/.rbenv/default-gems # gems'
alias migrate='bundle exec rake db:migrate db:test:clone parallel:prepare'
alias rollback='bundle exec rake db:rollback'
alias myip='ifconfig en0 | grep  inet\  | cut -d \  -f2 # myip'
alias du='dust'
alias ls='eza --icons=auto'
alias t='task'
alias g='git'

function vim() {
  if [[ $# -eq 0 ]]; then
    command vim -c ":FZFiles"
  else
    command vim "$@"
  fi
}
