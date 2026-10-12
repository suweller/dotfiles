#!/usr/bin/env bash

function yes-no() {
  read -p "$1 [y/n]" -n 1 -r
  echo '' # make sure we're on a newline
  [ $REPLY == "y" ] && return 0 || return 1
}

if [[ ! $(xcode-select -p) ]]; then
  $(xcode-select --install)
  yes-no 'Did Xcode install successfully?' || exit 1
fi

if [[ ! "$(command -v brew)" ]]; then
  echo "Install homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi


brew tap tinted-theming/tinted
brew trust tinted-theming/tinted
function brew-all {
  function may-brew {
    printf "%-50s" $1
    if brew ${assert} -1 | grep --silent $(echo $1); then
      printf "%30s\n" '[OK]'
    else
      printf "%30s\n\n" '[INSTALLING]'
      brew ${action} $1
      printf "\n\n"
    fi
    return 0
  }

  function many-brew {
    printf "\nbrew $2\n\n"
    local assert=$1
    local action=$2
    for item in ${brews[@]}; do
      may-brew $item
    done
  }

  local brews=(
    bash
    bat
    chruby
    cloc
    ctags
    curl
    dust
    eza
    fd
    fzf
    git
    git-delta
    grep
    hyperfine
    imagesnap
    jq
    k9s
    mise
    procs
    qsv
    readline
    reattach-to-user-namespace
    ripgrep
    ruby-build
    sd
    taskwarrior-tui
    tinty
    tmux
    vim
    yq
    zsh
  )
  many-brew 'list' 'install'
} && brew-all

cd lib
for entry in *; do
  ln -Ffs ~/.dotfiles/lib/$entry $HOME/.$entry
done
cd ..

ln -Ffs ~/.dotfiles/id_rsa.pub $HOME/.ssh/.id_rsa.pub

printf "%-50s" "Checking UserShell"
user_shell=$(dscl . -read "/Users/$USER" UserShell | awk '{print $2}')
if  echo $user_shell | grep --silent 'brew/bin/zsh'; then
  printf "%30s\n\n" '[OK]'
else
  printf "%30s\n\n" '[Updating]'
  echo "UserShell is currently: $user_shell"
  echo "Changing to brew zsh!"
  sudo chsh -s "$(command -v zsh)" "${USER}"
  chsh -s "$(which zsh)"
fi
