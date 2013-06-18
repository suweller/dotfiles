#!/bin/bash

function yesno() {
  read -p "$1? (y/n)" -n 1 -r
  echo '' # make sure we're on a newline
  [ $REPLY == "y" ] && return 0 || return 1
}

function symlink_file() {
  ln -s $PWD/$1 $HOME/.$1
}

cd lib

# Symlink each entry in lib to $HOME
for entry in *; do
  if [ -a "$HOME/.$entry" ]; then
    if (yesno "~/.$entry exists. overwrite"); then
      rm -rf $HOME/.$entry
      symlink_file $entry
    else
      echo "skipping: $entry"
    fi
  else
    symlink_file $entry
  fi
done

# Install Vundle if its not present
vundle="$PWD/vim/bundle/vundle"
if [ -a $vundle ]; then
  echo "vundle is already installed"
else
  echo $vundle
  git clone git://github.com/gmarik/vundle.git $vundle && \
  vim +BundleInstall +qall # Fetch and install all bundles included in vimrc
fi

cd ..

# Install oh-my-zsh if its not present
oh_my_zsh="$PWD/oh-my-zsh"
if [ -a $oh_my_zsh ]; then
  echo "oh-my-zsh is already installed"
else
  git clone git://github.com/bobbyrussel/oh-my-zsh $oh_my_zsh
fi

# # Handle ssh pubkey
id_rsa=$HOME/.ssh/id_rsa.pub
rm $id_rsa
ln -s $PWD/id_rsa.pub $id_rsa

echo "You can make zsh your default shell by running:"
echo "chsh -s /bin/zsh"
