_cd_code() {
  A_DIR='/Users/suweller/Documents/code/'
  R_DIR='~/Documents/code/'
  CMD='cd '
  BUFFER=$(fd . $A_DIR \
    --exact-depth=2 \
    --type=directory \
    | sd $A_DIR '' \
    | fzf \
    --bind="enter:become(echo '$CMD $R_DIR{1}')" \
    --preview="bat --color=always --language=md --style='snip' $R_DIR{1}/README.md" \
  )
  zle end-of-line
  zle accept-line
}
zle -N _cd_code
bindkey '^mj' _cd_code

_present_vimwiki() {
  A_DIR='/Users/suweller/vimwiki/work/diary/'
  R_DIR='~/vimwiki/work/diary/'
  CMD='presenterm --enable-snippet-execution'
  BUFFER=$(ls --only-files --reverse $A_DIR \
    | fzf \
    --accept-nth=1 \
    --ansi \
    --bind="enter:become(echo '$CMD $R_DIR{1}')" \
    --no-sort \
    --nth=1 \
    --preview="bat --color=always --language=md --line-range=:30 --style='snip' $R_DIR{1}" \
    --preview-window="right,70%"
  )
  zle end-of-line
  zle accept-line
}
zle -N _present_vimwiki
bindkey '^mp' _present_vimwiki

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
  echo "\e[0;32m󰓅  PLAIN= zsh\e[0;37m"
  repeat 3 time PLAIN= zsh --interactive -c exit
  echo "\n\e[0;32m󰾅  zsh\e[0;37m"
  repeat 3 time zsh --interactive -c exit
  echo "\n\e[0;31m󰾆  Slow?\e[0;37m Run:"
  echo "  ZPROF= zsh --interactive -c exit"
}


