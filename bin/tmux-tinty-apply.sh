#!/usr/bin/env bash

FZF_DEFAULT_COMMAND="tinty list"
FZF_DEFAULT_OPTS="\
  $FZF_DEFAULT_OPTS \
  --history $XDG_DATA_HOME/fzf/history-tinty_switch \
  --preview-window right,43 \
  --tmux center,80,25 \
 "

current_pane=$(tmux display-message -p '#{pane_id}')
cmd=$(tmux list-panes -F '#{pane_id} #{pane_current_command}' | awk -v p="$current_pane" '$1==p {print $2}')
become() {
  tinty apply "$1"
  # Check if the current pane is Vim/Neovim
  if [ "$cmd" = "vim" ] || [ "$cmd" = "nvim" ]; then
    tmux send-keys -t "$current_pane" Escape ':doautocmd FocusGained' Enter
  fi
}

previous_theme=$(tinty current)

selected_theme=$(
  PREVIOUS="$previous_theme" fzf \
    --accept-nth=1 \
    --bind "start,ctrl-r:reload:$FZF_DEFAULT_COMMAND" \
    --bind "enter:replace-query+accept" \
    --preview-label="$previous_theme" \
    --preview='tmux-tinty-preview.sh {}' \
    --tac
)

# Restore previous theme if cancelled
if [ -z "$selected_theme" ]; then
    become "$previous_theme"
else
    become "$selected_theme"
fi
