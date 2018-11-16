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

HOWTO_FILE=${SPP_HOME}/howto.txt
.howto() {
  _note "$HOWTO_FILE" "$@"
}
.howto.edit() {
  _note.edit "$HOWTO_FILE" "$@"
}
.howto.add() {
  _note.add "$HOWTO_FILE" "$@"
}
