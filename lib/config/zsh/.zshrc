# vim:foldmethod=marker
if [[ -v ZPROF ]]; then
  zmodload zsh/zprof
fi

# Make the $path array have unique values.
typeset -U path
function add2path() {
  path=("$1" $path)
}
typeset -U fpath
function add2fpath() {
  fpath=("$1" $fpath)
}

add2fpath "/opt/homebrew/share/zsh/site-functions"

add2path "$HOME/.dotfiles/bin"
add2path "/opt/homebrew/sbin"
add2path "/opt/homebrew/bin"
add2path "/opt/workbrew/bin"
add2path "/sbin"
add2path "/usr/local/bin"
add2path "/usr/sbin"

# Set Options {{{
setopt append_history
setopt auto_cd
setopt auto_pushd
setopt extended_history
setopt hist_expire_dups_first
setopt hist_fcntl_lock
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_lex_words
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt interactivecomments
setopt no_case_glob
setopt prompt_subst # Make sure prompt is able to be generated properly.
setopt pushd_ignore_dups
setopt pushd_silent
setopt rm_star_wait
setopt share_history
# }}}
unset GREP_OPTIONS
bindkey -e

zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zcompletion
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' ignore-case yes
zstyle ':completion:*' list-packed yes
zstyle ':completion:*' use-cache on
zstyle ':completion:*:*:task:*' format '[%d]'
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
zstyle ':completion:*:match:*' original only
zstyle ':fzf-tab:*' switch-group 'ctrl-h' 'ctrl-l'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':hist:*' expand-aliases yes

source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/functions.zsh"

PS1="%F{magenta}%(3~|%-1~/…/%1~|%1~)%F{white} $ %b "
if [[ -v PLAIN ]]; then
else
  if [[ -z "$TMUX" ]]; then
    tmux attach -t default || tmux new-session -s default || exit 1
    exit 0
  fi
  if [[ ! -d $ZGEN_DIR ]]; then
    git clone https://github.com/jandamm/zgenom.git $ZGEN_DIR
  fi
  source "$ZGEN_DIR/zgenom.zsh"

  # zgenom autoupdate
  if ! zgenom saved; then
    zgenom load 'jandamm/zgenom-ext-eval'
    zgenom eval <<-ZSH # {{{
      $(fzf --zsh)
      bindkey '^P' fzf-history-widget
      bindkey '^N' fzf-cd-widget
      # bindkey -r '^G'
      $(mise activate zsh)
      $(mise hook-env -s zsh)
ZSH
# }}}
    zgenom load 'marlonrichert/zsh-hist'
    zgenom load 'Aloxaf/fzf-tab'
    zgenom compile "$ZDOTDIR/.zshrc"
    zgenom save
    zsh-performance
  fi
fi

# Unset local functions
unset -f add2path
unset -f add2fpath

if [[ -v ZPROF ]]; then
 zprof | less
fi
