#!/bin/bash

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

if [[ ! -x  ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

function brew-all {
  function may-brew {
    printf "%-50s" $1
    if brew ${assert} -1 | grep -q $(echo $1 | sed 's/caskroom\/cask\///'); then
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
    caskroom/fonts
  )
  many-brew 'tap' 'tap'

  local brews=(
    autojump
    cloc
    ctags
    curl
    fzf
    git
    grep
    hyperfine
    imagesnap
    procs
    readline
    reattach-to-user-namespace
    ripgrep
    ruby-build
    ruby-install
    starship
    tmux
    vim
    zsh
  )
  many-brew 'list' 'install'
} && brew-all

cd lib
for entry in *; do
  ln -Ffs .dotfiles/lib/$entry $HOME/.$entry
done
cd ..

ln -Ffs .dotfiles/id_rsa.pub $HOME/.ssh/.id_rsa.pub

sudo chsh -s "$(command -v zsh)" "${USER}"
chsh -s "$(which zsh)"
