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
bindkey '^xj' _open_project

_open_vimwiki() {
  A_DIR='/Users/suweller/vimwiki/work/diary/'
  R_DIR='~/vimwiki/work/diary/'
  CMD='presenterm --enable-snippet-execution'
  BUFFER=$(fzf \
    --accept-nth=1 \
    --ansi \
    --bind "start,ctrl-r:reload:ls $A_DIR" \
    --bind="enter:replace-query+become(echo '$CMD $R_DIR{1}')" \
    --bind="tab:replace-query" \
    --nth=1 \
    --history="$XDG_DATA_HOME/fzf/history-open_vimwiki" \
    --preview-window="right,70%" \
    --preview="bat --color=always --language=md --line-range=:30 --style='snip' $R_DIR{1}" \
  )
  zle end-of-line
  zle accept-line
}
zle -N _open_vimwiki
bindkey '^xw' _open_vimwiki

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
bindkey '^xb' fzf-bindkey

jira() {
  export JIRA_HOST="https://fugamusic.atlassian.net"
  export JIRA_EMAIL="steven.weller@fuga.com"
  export JIRA_API_TOKEN=$(security find-generic-password -a "$USER" -s "JiraAPItoken" -w)
  unfunction "$0"
  jira $@
}

zsh-performance() {
  if (( hyperfine )); then
    hyperfine --shell=none 'env PLAIN= zsh --interactive -c exit' 'env zsh --interactive -c exit'
  else
    echo " 󰓅\e[0;32m PLAIN= zsh\e[0;37m"
    repeat 3 time PLAIN= zsh --interactive -c exit
    echo "\n 󰾅\e[0;32m zsh\e[0;37m"
    repeat 3 time zsh --interactive -c exit
  fi
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

# ============================================================================
# Task Planning System
# ============================================================================

_task_quick_capture() {
  BUFFER="task-capture "
  zle end-of-line
}
zle -N _task_quick_capture
bindkey '^xt' _task_quick_capture

_task_daily_plan() {
  BUFFER="task-daily-plan"
  zle accept-line
}
zle -N _task_daily_plan
bindkey '^xd' _task_daily_plan

_task_daily_review() {
  BUFFER="task-daily-review"
  zle accept-line
}
zle -N _task_daily_review
bindkey '^xr' _task_daily_review

_task_weekly_review() {
  BUFFER="task-weekly-review"
  zle accept-line
}
zle -N _task_weekly_review
bindkey '^xW' _task_weekly_review

_task_monthly_plan() {
  BUFFER="task-monthly-plan"
  zle accept-line
}
zle -N _task_monthly_plan
bindkey '^xM' _task_monthly_plan

_task_yearly_review() {
  BUFFER="task-yearly-review"
  zle accept-line
}
zle -N _task_yearly_review
bindkey '^xY' _task_yearly_review

# ============================================================================
# Voice Dictation System
# ============================================================================

_voice_task() {
  BUFFER="task-voice"
  zle accept-line
}
zle -N _voice_task
bindkey '^xv' _voice_task

_voice_vimwiki() {
  BUFFER="vimwiki-voice"
  zle accept-line
}
zle -N _voice_vimwiki
bindkey '^xn' _voice_vimwiki

_voice_claude() {
  BUFFER="voice-to-claude"
  zle accept-line
}
zle -N _voice_claude
bindkey '^xc' _voice_claude

# Reminder system - shows planning prompts at appropriate times
_task_daily_reminder() {
  # Only run in the first interactive shell of the day
  [[ ! -f "$XDG_CACHE_HOME/.task_reminder_$(date +%Y%m%d)" ]] || return

  local HOUR=$(date +%H)

  # Morning reminder (6am - 11am)
  if [[ $HOUR -ge 6 && $HOUR -lt 11 ]]; then
    echo "☀️  Good morning! Ready to plan your day? (Ctrl+X D)"
    touch "$XDG_CACHE_HOME/.task_reminder_$(date +%Y%m%d)"
  # Evening reminder (6pm - 11pm)
  elif [[ $HOUR -ge 18 && $HOUR -lt 23 ]]; then
    echo "☾ Time to review your day! (Ctrl+X R)"
    touch "$XDG_CACHE_HOME/.task_reminder_$(date +%Y%m%d)"
  fi

  # Weekly reminder (Sunday evening or Monday morning)
  local DOW=$(date +%u)  # 1=Monday, 7=Sunday
  if [[ ($DOW -eq 7 && $HOUR -ge 18) || ($DOW -eq 1 && $HOUR -lt 12) ]]; then
    if [[ ! -f "$XDG_CACHE_HOME/.task_weekly_reminder_$(date +%Y%W)" ]]; then
      echo " Weekly review time! (Ctrl+X Shift+W)"
      touch "$XDG_CACHE_HOME/.task_weekly_reminder_$(date +%Y%W)"
    fi
  fi

  # Monthly reminder (last day or first day of month)
  local DOM=$(date +%d)
  local LAST_DOM=$(date -j -v1d -v+1m -v-1d +%d 2>/dev/null || echo 31)
  if [[ $DOM -eq $LAST_DOM || $DOM -eq 1 ]]; then
    if [[ ! -f "$XDG_CACHE_HOME/.task_monthly_reminder_$(date +%Y%m)" ]]; then
      echo " Monthly planning time! (Ctrl+X Shift+M)"
      touch "$XDG_CACHE_HOME/.task_monthly_reminder_$(date +%Y%m)"
    fi
  fi
}
