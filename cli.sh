#!/usr/bin/env bash

export EDITOR=nvim
export BROWSER=chrome

export SPP_CLI_HOME="${HOME}/.spp/cli"
if [[ ! -d "$SPP_CLI_HOME" ]]; then
  mkdir -p "$SPP_CLI_HOME"
fi

export SPP_HOME="$HOME/_spp"
SRC="$SPP_HOME/src"

# shellcheck source=src/stats.sh
. "$SRC"/stats.sh
# shellcheck source=src/utils.sh
. "$SRC"/utils.sh
# shellcheck source=src/note.sh
. "$SRC"/note.sh
# shellcheck source=src/git.sh
. "$SRC"/git.sh
# shellcheck source=src/project.sh
. "$SRC"/project.sh
# shellcheck source=src/generate.sh
. "$SRC"/generate.sh
# shellcheck source=src/ticket.sh
. "$SRC"/ticket.sh
# shellcheck source=src/candidate.sh
# . "$SRC"/candidate.sh

.cli.backup() {
 cd "$SPP_HOME" && \
  git add .
  git commit -m "backup: $(.util.date)" 
  git push origin master
}

.cli.todo() {
  _note.inline "$SPP_HOME/cli.sh" "todo" "$@"
}

NOTES_FILE="$SPP_HOME"/notes.md
.note() {
  _note.get "$NOTES_FILE" "$@"
}
alias .n=.note

_note_titles() {
  local part="$1"
  grep -e "^## $part*" "$NOTES_FILE" | sed 's/## //' | sort
}

_note_complete() {
  local cmd="${1##*/}"
  local word=${COMP_WORDS[COMP_CWORD]}
  # local line=${COMP_LINE}
  mapfile -t COMPREPLY < <(_note_titles "$word")
}
complete -F _note_complete .note
complete -F _note_complete .n

.note.edit() {
  _note.edit "$NOTES_FILE" "$@"
}

.note.add() {
  _note.add "$NOTES_FILE" "$@"
}
alias .na=.note.add

.note.todo() {
  _note.inline "$SPP_HOME/note.sh" "todo" "$@"
}
# todo: pull request from cli
