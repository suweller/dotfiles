# vim:foldmethod=marker
if [[ -v ZPROF ]]; then
  zmodload zsh/zprof
fi

if [[ -v PLAIN ]]; then
  PS1="%F{magenta}%(3~|%-1~/…/%1~|%1~)%F{white} $ %b "
elif [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
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

add2fpath "$XDG_CONFIG_HOME/docker"
add2path "$HOME/.dotfiles/bin"
add2path "/sbin"
add2path "/usr/local/bin"
add2path "/usr/sbin"
add2path "/opt/homebrew/sbin"
add2path "/opt/homebrew/bin"

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

export TINTED_TMUX_OPTION_ACTIVE=1
export TINTED_SHELL_ENABLE_BASE16_VARS=1
export TINTED_SHELL_ENABLE_BASE24_VARS=1
export FZF_DEFAULT_OPTS=" \
  --layout=reverse \
  --style=minimal \
  --color=bg:0,fg:7,hl:3 \
  --color=bg+:8,fg+:0,hl+:11 \
  --color=info:5,border:5,prompt:2 \
  --color=pointer:0,marker:9,spinner:9,header:1 \
  "

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

if [[ -v PLAIN ]]; then
  PS1="%F{magenta}%(3~|%-1~/…/%1~|%1~)%F{white} $ %b "
else
  if [[ -z "$TMUX" ]]; then
    (tmux  -T 256 attach -t default || tmux  -T 256 new-session -s default -c ~/.dotfiles) && exit 0
  fi
  if [[ ! -d $ZGEN_DIR ]]; then
    git clone https://github.com/jandamm/zgenom.git $ZGEN_DIR
  fi
  source "$ZGEN_DIR/zgenom.zsh"

  # zgenom autoupdate
  if ! zgenom saved; then
    zgenom load 'romkatv/powerlevel10k' powerlevel10k
    zgenom load 'jandamm/zgenom-ext-eval'
    zgenom eval <<-ZSH # {{{
      $(fzf --zsh)
      bindkey '^P' fzf-history-widget
      bindkey '^N' fzf-cd-widget
      # bindkey -r '^G'
      $(mise activate zsh)
      $(mise hook-env -s zsh)
      $(/opt/homebrew/bin/brew shellenv)
ZSH
# }}}
    zgenom load 'Aloxaf/fzf-tab'
    zgenom load 'marlonrichert/zsh-hist'
    zgenom load 'reegnz/jq-zsh-plugin'
    zgenom compile $ZDOTDIR
    zgenom save
    zsh-performance
  fi

  [[ ! -f $XDG_CONFIG_HOME/zsh/.p10k.zsh ]] || source $XDG_CONFIG_HOME/zsh/.p10k.zsh
fi

# Unset local functions
unset -f add2path
unset -f add2fpath

if [[ -v ZPROF ]]; then
 zprof | less
fi
