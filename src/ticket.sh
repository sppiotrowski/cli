#!/usr/bin/env bash

# TODO: add ticket script desc

SPP_TICKET_CURRENT_FILE="${SPP_CLI_HOME}/.ticket_current"
SPP_DEFAULT_GIT_BRANCH=master

SPP_TICKETS_PATH="${SPP_CLI_HOME}/tickets"
if [[ ! -d "$SPP_TICKETS_PATH" ]]; then
  mkdir -p "$SPP_TICKETS_PATH"
fi

SPP_TICKET_PROJECTS_PATH="${SPP_CLI_HOME}/tickets_projects"
if [[ ! -d "$SPP_TICKET_PROJECTS_PATH" ]]; then
  mkdir -p "$SPP_TICKET_PROJECTS_PATH"
fi

JIRA_ID=1
GIT_PROJECT=2
DESC=3

__spp_ticket_get_current_branch() {
  git rev-parse --abbrev-ref HEAD
}

__spp_ticket_checkout_branch() {
  local jira_id="${1}"
  local desc="${2}"
  local branch="${jira_id}_${desc// /_}"
  local current_branch
  current_branch="$(__spp_ticket_get_current_branch)"

  if [[ -z $jira_id ]]; then
    echo "${FUNCNAME[0]}: jira_id is missing"
    return 1
  fi

  if [[ -z $desc ]]; then
    echo "${FUNCNAME[0]}: desc is missing"
    return 1
  fi

  if [[ $current_branch = "$branch" ]]; then
    return 0
  else
    if [[ $current_branch != "$SPP_DEFAULT_GIT_BRANCH" ]]; then
      echo "${FUNCNAME[0]}: in $current_branch instead of $SPP_DEFAULT_GIT_BRANCH"
      return 1
    fi
    git pull
    git checkout -b "${branch}"
  fi
}

__spp_ticket_set_current() {
  local jira_id="${1}"
  if [ -z "$jira_id" ]; then
    echo "current ticket: jira_id is missing"
    exit 1
  fi
  echo "$jira_id" > "$SPP_TICKET_CURRENT_FILE"
}

__spp_ticket_get_current() {
  local jira_id
  jira_id="$(< "$SPP_TICKET_CURRENT_FILE")"
  echo -n "$jira_id"
}

__spp_ticket_get_value() {
  local jira_id="${1}"
  local index="${2}"
  if [[ -z $jira_id ]]; then
    echo "jira_id is missing"
    return 1;
  fi
  if [[ -z $index ]]; then
    echo "index is missing"
    return 1;
  fi

  local ticket_path="${SPP_TICKETS_PATH}/${jira_id}"
  if [ -z "$ticket_path" ]; then
    echo "current ticket: file doesn't exist"
    exit 1
  fi
  sed -n "${index}p" "$ticket_path"
}

__spp_ticket_get_current_value() {
  local index="${1}"
  local current_jira_id
  current_jira_id="$(__spp_ticket_get_current)"
  local jira_id="${2:-$current_jira_id}"

  local ticket_path="${SPP_TICKETS_PATH}/${jira_id}"
  if [ -z "$ticket_path" ]; then
    echo "current ticket: file doesn't exist"
    exit 1
  fi
  sed -n "${index}p" "$ticket_path"
}

__spp_ticket_add() {
  local jira_url="${1}"
  if [ -z "$jira_url" ]; then
    echo "ticket: jira_url is missing"
    exit 1
  fi

  local git_project="${2}"
  if [ -z "$git_project" ]; then
    echo "ticket: git_project is missing"
    exit 1
  fi

  local desc="${*:3}"
  if [ -z "$desc" ]; then
    echo "ticket: desc is missing"
    exit 1
  fi

  local jira_id="${jira_url##*/}"
  if [ ! -d "$SPP_TICKETS_PATH" ]; then
    mkdir -p "$SPP_TICKETS_PATH"
  fi

  local ticket_file="${SPP_TICKETS_PATH}/${jira_id}"
  echo "$jira_id" > "$ticket_file"
  echo "$git_project" >> "$ticket_file"
  echo "$desc" >> "$ticket_file"

  __spp_ticket_set_current "$jira_id"
}

__spp_ticket_info() {
  local current_jira_id
  current_jira_id="$(__spp_ticket_get_current_value "$JIRA_ID")"
  local jira_id=${1:-$current_jira_id}

  local desc
  desc="$(__spp_ticket_get_value "$jira_id" "$DESC")"

  local git_project
  git_project="$(__spp_ticket_get_value "$jira_id" "$GIT_PROJECT")"

  local file_changed_date
  file_changed_date=$(stat -t "%Y.%m.%d" -f "%Sc" "${SPP_TICKETS_PATH}/${jira_id}")

  printf '%s %s %s %s\n' "$file_changed_date" "$jira_id" "$git_project" "$desc"
}

.ticket.add() {
  __spp_stat "${FUNCNAME[0]}"
  read -rp 'Jira id/url: ' jira_id
  read -rp 'Git project: ' git_project
  read -rp 'Ticket desc: ' desc
  __spp_ticket_add "$jira_id" "$git_project" "$desc"
}
alias .tadd=.ticket.add


.ticket.cd() {
  __spp_stat "${FUNCNAME[0]}"
  local jira_id
  jira_id="$(__spp_ticket_get_current_value "$JIRA_ID")"

  local desc
  desc="$(__spp_ticket_get_current_value "$DESC")"

  local git_project
  git_project="$(__spp_ticket_get_current_value "$GIT_PROJECT")"

  local git_project_path="${SPP_TICKET_PROJECTS_PATH}/${git_project}"
  if [ ! -d "$git_project_path" ]; then
    (cd "${SPP_TICKET_PROJECTS_PATH}" && git clone "git@github.com:paulsecret/${git_project}.git") && cd "$git_project_path" || return 1
  else
    cd "$git_project_path" || return 1
  fi

  __spp_ticket_checkout_branch "$jira_id" "$desc"

}
alias .tcd=.ticket.cd

.ticket.commit() {
  __spp_stat "${FUNCNAME[0]}"
  local desc
  desc="$(__spp_ticket_get_current_value "$DESC")"

  local jira_id
  jira_id="$(__spp_ticket_get_current_value "$JIRA_ID")"

  local git_project
  git_project="$(__spp_ticket_get_current_value "$GIT_PROJECT")"

  local git_project_path="${SPP_TICKET_PROJECTS_PATH}/${git_project}"

  if [ "$git_project_path" != "$(pwd)" ]; then
    echo "ticket.commit: wrong directory"
  fi

  local pr_msg="${1:-$desc}"
  git commit -m "${jira_id} - ${pr_msg}"
}
alias .tc=.ticket.commit

.ticket.help() {
  __spp_stat "${FUNCNAME[0]}"
  cat <<END
  .ticket.help       # displays this message
  .ticket.info       # displays a ticket info

  .ticket.add        # init jira/poject/desc
  .ticket.cd         # cd project (setup branch)
  .ticket.commit     # commit changes

  .ticket.pr.build   # run Jenkins job for the PR branch
  .ticket.pr.create  # create a new Github PR
  .ticket.pr.msg     # create a new Slack PR request

  .ticket.pr.merge   # merge Github PR to the main branch
  .ticket.rel.build  # run Jenkins job for the main branch
  .ticket.rel.msg    # create a new Slack pull request request
  .ticket.done.jira  # close Jira ticket
END
}
alias .th=.ticket.help

.ticket.info() {
  __spp_stat "${FUNCNAME[0]}"
  __spp_ticket_info "$1"
}
alias .ti=.ticket.info

.ticket.ls() {
  __spp_stat "${FUNCNAME[0]}"
  for ticket in "${SPP_TICKETS_PATH}"/*; do
    local jira_id
    jira_id=$(basename "$ticket")
    __spp_ticket_info "$jira_id"
  done
}
alias .tls=.ticket.ls
