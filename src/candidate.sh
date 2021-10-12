#!/usr/bin/env bash

CURRENT="$HOME/_current"

.cd.current() {
  cd "$CURRENT" || return 1
}

.current() {
  local dir="${1:-$PWD}"  
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
