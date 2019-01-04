#!/usr/bin/env bash

CURRENT="$HOME/_current"

.finder.current() {
  local dir="$1"  
  if [ ! -d "$dir" ]; then
    echo 'path is missing...'
    return 1
  fi

  if [ -L "$CURRENT" ]; then
    rm "$CURRENT"
  fi

  if [ -d "$dir" ]; then
    cmd="ln -s ${dir}/ $CURRENT"
    eval "$cmd"
  fi
}
