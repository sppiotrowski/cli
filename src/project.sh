#!/usr/bin/env bash

PROJECTS_PATH="${HOME}/projects"

.cd() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"

  local part="$1"
  local projects=($(ls -d ${PROJECTS_PATH}/*${part}* 2> /dev/null))

  if [[ ${#projects[@]} -eq 0 ]]; then
    # TODO: exclude projects dir from the list
    cd "$PROJECTS_PATH/$(ls "$PROJECTS_PATH" | fzf)" || return 1
  elif [[ ${#projects[@]} -eq 1 ]]; then
    cd "${projects[1]}"
  elif [[ ${#projects[@]} -gt 1 ]]; then
    cd "$PROJECTS_PATH/$(find "${PROJECTS_PATH}" -name "*${part}*" -maxdepth 1 -type d -exec basename {} \; | fzf)" || return 1
  else
    # TODO: exclude projects dir from the list
    cd "$PROJECTS_PATH/$(ls "$PROJECTS_PATH" | fzf)" || return 1
  fi
}
