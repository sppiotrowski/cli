#!/usr/bin/env bash

PROJECTS_PATH="${HOME}/projects"

.cd() {
    APP_PART="$1"
    local path="$PROJECTS_PATH/$APP_PART"
    if [ -d "$path" ]; then
      cd "$path" || return 1
    else
      cd "$PROJECTS_PATH" || return 1
    fi
}

_project_name() {
  local name="$1"
  if [ -z "$name" ]; then
    cmd="ls -d $PROJECTS_PATH/* | xargs basename"
    eval "$cmd"
  else
    cmd="ls -d $PROJECTS_PATH/*${name}* | xargs basename"
    eval "$cmd"
  fi
}

_cd_complete() {
  # http://www.linuxjournal.com/content/more-using-bash-complete-command
  # local cmd="${1##*/}"
  # local line="${COMP_LINE}"
  local word=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=("$(_project_name "$word")")
}

complete -F _cd_complete .cd
