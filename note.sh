#!/usr/bin/env bash

# manage note file
# _note.add <topic> <content> => # <topic> <\n> <content>

_note() {
  local file="$1"; shift
  local topic="$1"; shift
  local cmd="sed -n '/$topic/,/#/p' $file"
  eval "$cmd"
}

_note.edit() {
  local file="$1"; shift
  local topic="$1"; shift
  local cmd="vim +/$topic $file"
  eval "$cmd"
}

_note.add() {
  local file="$1"; shift
  local topic="$1"; shift
  local tail="$*"
  echo '' >> "$file"
  local cmd="echo '# $topic' >> $file"
  eval "$cmd"
  local cmd_tail="echo '$tail' >> $file"
  eval "$cmd_tail"
}

_note.inline() {
  local file="$1"; shift
  local topic="$1"; shift
  local tail="$*"
  local cmd="echo '# $topic': $tail >> $file"
  eval "$cmd"
}
