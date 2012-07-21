#!/bin/bash
ENTRIES='*'
EXCLUDED=(LICENSE README.md id_rsa.pub install.sh oh-my-zsh)

function excluded() {
  for excluded_entry in ${EXCLUDED[@]}; do
    if [ $1 == $excluded_entry ]; then
      return 0
    fi
  done
  return 1
}

function yesno() {
  read -p "$1? (y/n)" -n 1 -r
  echo ''
  [ $REPLY == "y" ] && return 0 || return 1
}

function symlink_file() {
  ln -s $PWD/$1 $HOME/.$1
}

for entry in $ENTRIES; do
  if (excluded $entry); then
    continue
  fi
  if [ -a "$HOME/.$entry" ]; then
    if (yesno "~/.$entry exists. overwrite"); then
      rm -rf $HOME/.$entry
      symlink_file $entry
    else
      echo "$entry is skipped"
    fi
  else
    symlink_file $entry
  fi
done

# Install oh-my-zsh if its not present
oh_my_zsh="$PWD/oh-my-zsh"
if [ -a $oh_my_zsh ]; then
  echo "oh-my-zsh is already installed"
  git clone git://github.com/bobbyrussel/oh-my-zsh $oh_my_zsh
fi

# Handle ssh pubkey
id_rsa=$HOME/.ssh/id_rsa.pub
rm $id_rsa
ln -s $PWD/id_rsa.pub $id_rsa

# Install Vundle if its not present
vundle="$PWD/vim/bundle/vundle"
if [ -a $vundle ]; then
  echo "vundle is already installed"
else
  git clone git://github.com/gmarik/vundle.git $vundle
  vim +BundleInstall +qall # Fetch and install all bundles included in vimrc
fi

echo "You can make zsh your default shell by running:"
echo "chsh -s /bin/zsh"
