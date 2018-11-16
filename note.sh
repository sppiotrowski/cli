#!/usr/bin/env bash

# manage note file
# _note.add <topic> <content> => # <topic> <\n> <content>

_note.get() {
  local file="$1"; shift
  local topic="$1"; shift
  if [ -z "$topic" ]; then
    local cmd="cat $file"
  else
    local cmd="sed -n '/$topic/,/#/p' $file"
  fi
  eval "$cmd"
}

_note.edit() {
  local file="$1"; shift
  local topic="$1"; shift
  if [ -z "$topic" ]; then
    local cmd="vim $file"
  else
    local cmd="vim +/$topic $file"
  fi
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
# todo: handle empty label when note.get
