#!/usr/bin/env bash

# manage note file
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

__note_titles() {
  local part="$1"
  grep -e "^# $part" notes.txt | sed 's/# //' | sort
}

__note_complete() {
  # local cmd="${1##*/}"
  # local line="${COMP_LINE}"
  local word=${COMP_WORDS[COMP_CWORD]}
   if [ -z "$word" ]; then
     COMPREPLY=("$(__note_titles)")
   else
     COMPREPLY=("$(__note_titles "$word")")
   fi
}
complete -F __note_complete _note.get
