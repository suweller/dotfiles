# Steven Weller's dot files

These are config files to set up a system the way I like it.
Vim-users will likely find useful stuff in
`vimrc`,
and `vim/config/*`.
I like aliases.
You might find a few you like in `zsh/aliases`.

# Installation

The whole installation process is managed by the install shell script.

    git clone git://github.com/suweller/dotfiles ~/.dotfiles
    cd ~/.dotfiles
    ./install.sh

## VIM

Vim plugins are handled by the `Vundle` vim plugin.
This plugin is fetched and placed in the correct directory by cloning the
git repository: https://github.com/gmarik/vundle

After its fetched,
it will launch vim to fetch and install all other plugins.
