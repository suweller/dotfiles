#!/usr/bin/env bash

tinty apply "$1"
paste \
  <(tinty info "$PREVIOUS" | tail -n +3 | sd '^(.+)  (.+)$' '$2  $1') \
  <(tinty info "$1" | tail -n +3)
