#!/usr/bin/env bash

SPP_NOTES_HOME=${HOME}/projects/prv


__spp_note_edit() {
  local topic="$1"

  if [ -z "$topic" ]; then
    echo topic is missing
    return 1
  fi

  "$EDITOR" "${SPP_NOTES_HOME}/${topic^^}.md"
}

.note.bash() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"
  __spp_note_edit bash
}
alias .nb=.note.bash

.note.js() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"
  __spp_note_edit js
}
alias .nj=.note.js

.note.git() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"
  __spp_note_edit git
}
alias .ng=.note.git

.note.vim() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"
  __spp_note_edit vim
}
alias .nv=.note.vim

.note.work() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"
  __spp_note_edit work
}
alias .nw=.note.work

.note.prv() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"
  __spp_note_edit prv
}
alias .np=.note.prv
