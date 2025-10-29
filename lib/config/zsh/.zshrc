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

jira() {
  export JIRA_HOST="https://fugamusic.atlassian.net"
  export JIRA_EMAIL="steven.weller@fuga.com"
  export JIRA_API_TOKEN=$(security find-generic-password -a "$USER" -s "JiraAPItoken" -w)
  unfunction "$0"
  jira $@
}

fzf-bindkey() {
  ( bindkey \
    | sd '^' 'zsh ' \
    && tmux list-keys \
    | rg --invert-match ' root ' \
    | sd '^bind-key[^T]+T ' 'tmux ' \
    ) \
    | sd '\^(.)' 'ctrl+$1 ' \
    | fzf
}

zsh-performance() {
  echo "\e[0;32m󰓅  PLAIN= zsh\e[0;37m"
  repeat 3 time PLAIN= zsh --interactive -c exit
  echo "\n\e[0;32m󰾅  zsh\e[0;37m"
  repeat 3 time zsh --interactive -c exit
  echo "\n\e[0;31m󰾆  Slow?\e[0;37m Run:"
  echo "  ZPROF= zsh --interactive -c exit"
}

cd-code() {
  dir='/Users/suweller/Documents/code/'
  BUFFER="cd $(
    fd . $dir \
      --exact-depth=2 \
      --type=directory \
      | sd $dir '' \
      | fzf --tmux \
      | sd '^(.+)' '~/Documents/code/$1'
    )"
  zle end-of-line
}
zle -N cd-code
bindkey '^w' cd-code

zle -N openapp
bindkey '^G' openapp

PS1="%F{green}󰓅 %F{white}20%D{%y/%m/%f} %*%B %F{magenta}%(3~|%-1~/…/%1~|%1~)%F{white} $ %b "
if [[ -v PLAIN ]]; then
else
  if [ -z "$TMUX" ]; then
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
    # zgenom eval --name starship "$(starship init zsh)"
    zgenom load 'marlonrichert/zsh-hist'
    zgenom eval --name fzf-config <<-ZSH # {{{
      $(fzf --zsh)
      bindkey '^P' fzf-history-widget
      bindkey '^N' fzf-cd-widget
      # bindkey -r '^G'
ZSH
# }}}
    zgenom load 'Aloxaf/fzf-tab'
    zgenom eval --name mise_config <<-ZSH # {{{
      $(mise activate zsh)
      $(mise hook-env -s zsh)
ZSH
# }}}
    zgenom compile "$ZDOTDIR/.zshrc"
    echo "\e[0;31m 󰇷  Fixing workbrew mistake so compaudit works"
    set -o xtrace
    sudo chown -RL $(id -run) /opt/homebrew/share/zsh /opt/homebrew/share/zsh/site-functions
    set +o xtrace
    echo "\e[0;37m"
    zgenom save
    echo "\e[0;31m 󰇷  Unfixing workbrew mistake so brew install works"
    set -o xtrace
    sudo chown -R workbrew /opt/homebrew/share/zsh /opt/homebrew/share/zsh/site-functions
    set +o xtrace
    echo "\e[0;37m"
    zsh-performance
  fi
fi

# Unset local functions
unset -f add2path
unset -f add2fpath

if [[ -v ZPROF ]]; then
 zprof | less
fi
