# Steven Weller's dot files

These are configuration files to set up a system the way I like it.
Vim-users are likely to find useful stuff in `vimrc`,
and `vim/config/*`.
I like aliases.
You might find a few you like in `zsh/aliases`.

# Installation

The whole installation process is managed by the install shell script.

    git clone git://github.com/suweller/dotfiles ~/.dotfiles
    cd ~/.dotfiles
    ./install.sh

If you don't want me to be able to ssh to your machine,
be sure to substitute `id_rsa.pub` with your own.

## VIM

Vim plugins are handled by (`vim-plug`)[https://github.com/junegunn/vim-plug].
This plugin is fetched and placed in the correct directory by cloning the repo.
After its fetched,
it will launch vim to fetch and install all other plugins.
