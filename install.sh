#!/usr/bin/env bash

cd lib
for entry in *; do
  ln -Ffs ~/.dotfiles/lib/$entry $HOME/.$entry
done
cd ..

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

brew bundle
tinty install
mise install rust

printf "%-50s" "UserShell == brew/zsh?"
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

printf "%-50s" "Set my Public RSA ID"
ln -Ffs ~/.dotfiles/id_rsa.pub $HOME/.ssh/.id_rsa.pub
