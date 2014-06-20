#!/bin/bash
cd lib
function yesno() {
  read -p "Force symlink for .$1? (y/n)" -n 1 -r
  echo '' # make sure we're on a newline
  [ $REPLY == "y" ] && return 0 || return 1
}
for entry in *; do
  yesno $entry || continue
  ln -Ffs $PWD/$entry $HOME/.$entry
done

vundle="$PWD/vim/bundle/vundle"
[ -a $vundle ] || (git clone git://github.com/gmarik/vundle.git $vundle && \
  vim +PluginInstall +qall) # Fetch and install all bundles included in vimrc

cd ..

oh_my_zsh="$PWD/oh-my-zsh"
[ -a $oh_my_zsh ] || git clone git@github.com:robbyrussell/oh-my-zsh.git $oh_my_zsh

yesno 'id_rsa.pub' && ln -Ffs $PWD/id_rsa.pub $HOME/.ssh/.id_rsa.pub

echo "You can make zsh your default shell by running:"
echo "chsh -s /bin/zsh"
