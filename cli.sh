#!/usr/bin/env bash

# setup env
export EDITOR=vim
export BROWSER=chrome
export SPP_HOME=${HOME}/_spp

# shellcheck source=note.sh
. ./note.sh

alias .date='echo $(date +%Y.%m.%d)'

.cli.backup() {
  cd "$SPP_HOME" && \
  git add .
  git commit -m "backup: $(.date)" 
  git push origin master
}

.cli.todo() {
  _note.inline "$SPP_HOME/cli.sh" "todo" "$@"
}

NOTES_FILE=${SPP_HOME}/notes.txt
.note.get() {
  _note.get "$NOTES_FILE" "$@"
}
.note.edit() {
  _note.edit "$NOTES_FILE" "$@"
}
.note() {
  _note.add "$NOTES_FILE" "$@"
}
.note.todo() {
  _note.inline "$SPP_HOME/note.sh" "todo" "$@"
}
