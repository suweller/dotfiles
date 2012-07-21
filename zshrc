# Path to your oh-my-zsh configuration.
ZSH=$HOME/.dotfiles/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Never know when you're gonna need to popd!
# setopt AUTO_PUSHD

# Allow completing of the remainder of a command
bindkey "^N" insert-last-word

# Show contents of directory after cd-ing into it
chpwd() {
  ls -lrthG
}

# Save a ton of history
HISTSIZE=20000
HISTFILE=~/.zsh_history
SAVEHIST=20000

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Disable flow control commands (keeps C-s from freezing everything)
stty start undef
stty stop undef

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(vi-mode git rails3 ruby bundler rvm terminalapp history-substring-search cap compleat)

source $ZSH/oh-my-zsh.sh
setopt interactivecomments

# Source my custom files after oh-my-zsh so I can override things.
source $HOME/.dotfiles/zsh/aliases
source $HOME/.dotfiles/zsh/functions

# Customize to your needs...
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin
export PATH=$PATH:~/.dotfiles/bin:~/.rvm/bin

export EDITOR='vim'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM

export LANG="en_US.utf-8"
export LC_ALL="en_US.utf-8"
export LC_CTYPE="utf-8"
