#!/usr/bin/env bash

fd '.app$' {,~}/Applications \
  --max-depth=1 \
  | sd '(.*/Applications/(.+).app/?$)' '\033[0;35m$2\t\033[0m $1' \
  | fzf \
  --accept-nth=1 \
  --ansi \
  --bind='enter:become(open -n {2})' \
  --delimiter="\t" \
  --nth=1 \
  --tmux
