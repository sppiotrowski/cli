#!/usr/bin/env bash

SCRIPT="$(realpath "$0")"
SCRIPT_PATH="$(dirname "$SCRIPT")"
DICT_PATH="${SCRIPT_PATH}/generate_dict"

_gen_shuffle() {
  local path="${1}"
  if [ -z "$path" ]; then
    echo "gen: shuffle path: ${path} doesn't exist"
    return 1
  fi
  gshuf "$path" | head -n 1 | tr -d '\n'
}

_gen_emoji() {
  local path="${1}"
  _gen_shuffle "${DICT_PATH}/emojis/${path}.txt"
}

_gen_saying() {
  local path="${1}"
  _gen_shuffle "${DICT_PATH}/sayings/${path}.txt"
}

.gen.morning() {
  echo "$(_gen_saying morning) $(_gen_emoji morning)"
}
alias .gm=.gen.morning

.gen.pull_request() {
  echo "$(_gen_saying morning) $(_gen_emoji morning)"
}
