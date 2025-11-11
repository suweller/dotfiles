_open_project() {
  A_DIR='/Users/suweller/Documents/code/'
  R_DIR='~/Documents/code/'
  CMD='cd '
  BUFFER=$(fd . $A_DIR \
    --exact-depth=2 \
    --type=directory \
    | sd $A_DIR '' \
    | fzf \
    --bind="enter:become(echo '$CMD $R_DIR{1} && \$EDITOR')" \
    --preview-window='right,70%' \
    --preview="bat \
      --color=always \
      --style='snip' \
      --terminal-width="\${FZF_PREVIEW_COLUMNS:-}" \
      --wrap=character \
      $R_DIR{1}/README.md \
      || ls $R_DIR{1}"
  )
  zle end-of-line
  zle accept-line
}
zle -N _open_project
bindkey '^mj' _open_project

_present_vimwiki() {
  A_DIR='/Users/suweller/vimwiki/work/diary/'
  R_DIR='~/vimwiki/work/diary/'
  CMD='presenterm --enable-snippet-execution'
  BUFFER=$(fzf \
    --accept-nth=1 \
    --ansi \
    --bind "start,ctrl-r:reload:ls $A_DIR" \
    --bind="enter:become(echo '$CMD $R_DIR{1}')" \
    --nth=1 \
    --history="$XDG_DATA_HOME/fzf/history-present_vimwiki" \
    --preview-window="right,70%" \
    --preview="bat --color=always --language=md --line-range=:30 --style='snip' $R_DIR{1}" \
  )
  zle end-of-line
  zle accept-line
}
zle -N _present_vimwiki
bindkey '^mp' _present_vimwiki

_tinty_switch() {
  BUFFER=$(fzf \
    --accept-nth=1 \
    --ansi \
    --bind "start,ctrl-r:reload:tinty list" \
    --bind="enter:become(echo 'tinty apply {1}')" \
    --history="$XDG_DATA_HOME/fzf/history-tinty_switch" \
    --preview-label="$(tinty current)" \
    --preview-window="right,42" \
    --preview="paste \
      <(tinty info $(tinty current) | tail -n +3 | sd '^(.+)  (.+)$' '\$2  \$1') \
      <(tinty info {} | tail -n +3) \
      | sd '^\t' '                    \t' \
      | column -t -s\"\t\"" \
    --tac \
  )
  zle end-of-line
  zle accept-line
}
zle -N _tinty_switch
bindkey '^mc' _tinty_switch

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
zle -N fzf-bindkey
bindkey '^mb' fzf-bindkey

jira() {
  export JIRA_HOST="https://fugamusic.atlassian.net"
  export JIRA_EMAIL="steven.weller@fuga.com"
  export JIRA_API_TOKEN=$(security find-generic-password -a "$USER" -s "JiraAPItoken" -w)
  unfunction "$0"
  jira $@
}

zsh-performance() {
  echo " 󰓅\e[0;32m PLAIN= zsh\e[0;37m"
  repeat 3 time PLAIN= zsh --interactive -c exit
  echo "\n 󰾅\e[0;32m zsh\e[0;37m"
  repeat 3 time zsh --interactive -c exit
  echo "\n 󰾆\e[0;31m Slow?\e[0;37m Run:"
  echo "  ZPROF= zsh --interactive -c exit"
}

local workbrew_bleed=(
  /opt/homebrew/share/zsh
  /opt/homebrew/share/zsh/site-functions
  /opt/homebrew/Cellar/zsh/5.9/share/zsh/functions
  /opt/homebrew/Cellar/zsh/5.9/share/zsh
)

embrew() {
  echo "\e[0;32m 󱍅 This is a custom function wrapping brew\e[0m"
  echo "  \$workbrew_bleed="
  printf "    %s\n" $workbrew_bleed
  echo " 󰇷\e[0;31m sudo chown -R workbrew \$workbrew_bleed\e[0m to fix:" \
    "\e[0;32m brew\e[0m $@"
  sudo chown -R workbrew $workbrew_bleed
  /opt/workbrew/bin/brew "$@"
  echo " 󰇷\e[0;31m sudo chown -RL $(id -run) \$workbrew_bleed\e[0m to fix:" \
    "\e[0;32m brew\e[0m $1"
  sudo chown -RL $(id -run) $workbrew_bleed
}

brew() {
  case $1 in
    doctor)
      embrew "$@"
      ;;
    install | uninstall | upgrade | update)
      embrew "$@"
      echo "\e[0;32m 󱍅 zgenom reset: Resetting zgenom caches\e[0m"
      zgenom reset
      ;;
    *)
      /opt/workbrew/bin/brew "$@"
      ;;
  esac
}
