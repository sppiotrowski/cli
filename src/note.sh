#!/usr/bin/env bash

TITLE_MARKUP=##
EDITOR=nvim

_note.get() {
  local file="$1"; shift
  local topic="$1"; shift
  if [ -z "$topic" ]; then
    local cmd="cat $file"
  else
    local cmd="sed -n '/^$TITLE_MARKUP $topic/,/^$TITLE_MARKUP /p' $file"
  fi
  eval "$cmd" | sed '1d;$d'
}

_note.edit() {
  local file="$1"; shift
  local topic="$1"; shift
  if [ -z "$topic" ]; then
    local cmd="$EDITOR $file"
  else
    local cmd="$EDITOR +/$topic $file"
  fi
  eval "$cmd"
}

__get_title() {
  local file="$1"; shift
  local topic="$1"; shift
  grep "## $topic$" "$file"
}

__append() {
  local file="$1"; shift
  local topic="$1"; shift
  local tail="$1"; shift
  # shellcheck disable=SC1117
  local cmd="sed -i '' -e '/## $topic/s/$/\' -e '$tail/' $file"
  eval "$cmd"
}

_note.add() {
  local file="$1"; shift
  local topic="$1"; shift
  local tail="$*"
  if [ -z "$(__get_title "$file" "$topic")" ]; then
    echo '' >> "$file"
    local cmd="echo '$TITLE_MARKUP $topic' >> $file"
    eval "$cmd"
    local cmd_tail="echo '$tail' >> $file"
    eval "$cmd_tail"
  else
    __append "$file" "$topic" "$tail"
  fi
}

_note.inline() {
  local file="$1"; shift
  local topic="$1"; shift
  local tail="$*"
  local cmd="echo '$TITLE_MARKUP $topic': $tail >> $file"
  eval "$cmd"
}

