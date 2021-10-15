#!/usr/bin/env bash

CURRENT_TICKET_PATH="${HOME}/.ticket"
TICKETS_PATH="${HOME}/.tickets"
POJECTS_PATH="${HOME}/_tickets_projects"

JIRA_ID=1
GIT_PROJECT=2
DESC=3

# TODO add usage stats

_set_current_ticket() {
  local jira_id="${1}"
  if [ -z "$jira_id" ]; then
    echo "current ticket: jira_id is missing"
    exit 1
  fi
  echo "$jira_id" > "$CURRENT_TICKET_PATH"
}

_get_current_jira_id() {
  local jira_id
  jira_id="$(< "$CURRENT_TICKET_PATH")"
  echo -n "$jira_id"
}

_get_current_value() {
  local index="${1}"
  local jira_id
  jira_id="$(_get_current_jira_id)"
  local ticket_path="${TICKETS_PATH}/${jira_id}"
  if [ -z "$ticket_path" ]; then
    echo "current ticket: file doesn't exist"
    exit 1
  fi
  sed -n "${index}p" "$ticket_path"
}

_ticket_add() {
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

  local desc="${*:2}"
  if [ -z "$desc" ]; then
    echo "ticket: desc is missing"
    exit 1
  fi

  local jira_id="${jira_url##*/}"
  if [ ! -d "$TICKETS_PATH" ]; then
    mkdir -p "$TICKETS_PATH"
  fi

  local ticket_file="${TICKETS_PATH}/${jira_id}"
  echo "$jira_id" > "$ticket_file"
  echo "$git_project" >> "$ticket_file"
  echo "$desc" >> "$ticket_file"

  # echo "${emoji} PR to [${ticket_desc}](${jira_url}). ${ask}" >> "$TICKET_FILE"
}

.ticket.add() {
  read -rp 'Jira id/url: ' jira_id
  read -rp 'Git project: ' git_project
  read -rp 'Ticket desc: ' desc
  _ticket_add "$jira_id" "$git_project" "$desc"
}
alias .tadd=.ticket.add

.ticket.cd() {
  local jira_id
  jira_id="$(_get_current_value "$JIRA_ID")"

  local desc
  desc="$(_get_current_value "$DESC")"

  local git_project
  git_project="$(_get_current_value "$GIT_PROJECT")"

  local git_project_path="${POJECTS_PATH}/${git_project}"
  if [ -z "$git_project_path" ]; then
    (cd "${POJECTS_PATH}" && git clone "git@github.com:paulsecret/${git_project}.git")
  fi

  cd "$git_project" || return 1
  git pull

  local branch="${jira_id}_${desc// /_}"
  git checkout -b "${branch}"
}
alias .tcd=.ticket.cd

.ticket.commit() {
  local desc
  desc="$(_get_current_value "$DESC")"

  local jira_id
  jira_id="$(_get_current_value "$JIRA_ID")"

  local git_project
  git_project="$(_get_current_value "$GIT_PROJECT")"

  local git_project_path="${POJECTS_PATH}/${git_project}"

  if [ "$git_project_path" != "$(pwd)" ]; then
    echo "ticket.commit: wrong directory"
  fi

  local pr_msg="${1:-desc}"
  git commit -m "${jira_id} - ${pr_msg}"
}
alias .tc=.ticket.commit

.ticket.help() {
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
  local jira_id
  jira_id="$(_get_current_value "$JIRA_ID")"

  local desc
  desc="$(_get_current_value "$DESC")"

  local git_project
  git_project="$(_get_current_value "$GIT_PROJECT")"
  echo "${git_project} ${jira_id} ${desc}"
}

alias .ti=.ticket.info
