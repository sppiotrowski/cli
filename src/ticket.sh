#!/usr/bin/env bash

# TODO: add ticket script desc
# set -o xtrace

SPP_TICKET_CURRENT_FILE="${SPP_CLI_HOME}/.ticket_current"
SPP_DEFAULT_GIT_BRANCH=master

SPP_TICKETS_PATH="${SPP_CLI_HOME}/tickets"
if [[ ! -d "$SPP_TICKETS_PATH" ]]; then
  mkdir -p "$SPP_TICKETS_PATH"
fi

SPP_TICKETS_DONE_PATH="${SPP_TICKETS_PATH}_done"
if [[ ! -d "$SPP_TICKETS_DONE_PATH" ]]; then
  mkdir -p "$SPP_TICKETS_DONE_PATH"
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

__spp_ticket_get_branch() {
  local jira_id="${1}"
  local desc="${2}"
  local branch="${jira_id}_${desc// /_}"
  echo -n "$branch"
}
__spp_ticket_checkout_branch() {
  local jira_id="${1}"
  local desc="${2}"
  local branch
  branch="$(__spp_ticket_get_branch "$jira_id" "$desc")"
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
    if [[ -z "$(git rev-parse --verify "$current_branch" 2>/dev/null)" ]]; then
      git checkout master
      git pull
      git checkout -b "${branch}"
    fi
    git checkout "${branch}"
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

BOLD=$(tput bold)
DEFAULT=$(tput sgr0)

__spp_ticket_info() {
  local jira_id="${1:-$(__spp_ticket_get_current_value "$JIRA_ID")}"
  local option="${2-}"
  local desc
  desc="$(__spp_ticket_get_value "$jira_id" "$DESC")"
  local git_project
  git_project="$(__spp_ticket_get_value "$jira_id" "$GIT_PROJECT")"
  # local file_changed_date
  # file_changed_date=$(stat -t "%Y.%m.%d" -f "%Sc" "${SPP_TICKETS_PATH}/${jira_id}")

  if [[ "$option" = '--porcelain' || "$option" = '-p' ]]; then
    printf '%s %s %s\n' "$jira_id" "$git_project" "$desc"
  else
    printf '%s %s %s\n' "$jira_id" "${BOLD}${git_project}${DEFAULT}" "$desc"
  fi
}

.ticket.add() {
  __spp_stat "${FUNCNAME[0]}"
  read -rp 'Jira id/url: ' jira_id
  read -rp 'Git project: ' git_project
  read -rp 'Ticket desc: ' desc
  __spp_ticket_add "$jira_id" "$git_project" "$desc"
}
alias .tadd=.ticket.add

# init
# * clone
# * co -b
# * co
# * npm i

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
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"
  local desc
  desc="$(__spp_ticket_get_current_value "$DESC")"

  local jira_id
  jira_id="$(__spp_ticket_get_current_value "$JIRA_ID")"

  local git_project
  git_project="$(__spp_ticket_get_current_value "$GIT_PROJECT")"

  local git_project_path="${SPP_TICKET_PROJECTS_PATH}/${git_project}"

  if [ "$git_project_path" != "$(pwd)" ]; then
    echo "$func_name: wrong directory"
  fi

  local pr_msg="${1:-$desc}"

  if [[ ! -z $(git status -s) ]]; then
    read -rp "$func_name: staged files, add? [Y/n]" choice
    if [[ $choice = 'n' ]]; then
      return 1
    fi
    git add -p
  fi
  git commit -m "${jira_id} - ${pr_msg}"
}
alias .tc=.ticket.commit

.ticket.help() {
  __spp_stat "${FUNCNAME[0]}"
  cat <<END
  .ticket.help       .th    # displays this message
  .ticket.info       .ti    # displays a ticket info
  .ticket.ls         .tls   # list tickets info
  .ticket.switch     .ts    # switch current ticket

  .ticket.add        .tadd  # init jira/poject/desc
  .ticket.cd         .tcd   # cd project (setup branch)
  .ticket.commit     .tc    # commit changes

  .ticket.pr.create  .tpc   # create a new Github PR
  .ticket.pr.build   .tpb   # run Jenkins job for the PR branch
  .ticket.pr.msg     .tpm   # [TODO]  # create a new Slack PR request

  .ticket.pr.merge   .tpm   # [TODO] merge Github PR to the main branch
  .ticket.rel.build  .trb   # run Jenkins job for the main branch
  .ticket.rel.msg    .trm   # [TODO] create a new Slack pull request request
  .ticket.done       .tdone # close the ticket
END
}
alias .th=.ticket.help


__spp_ticket_git_check_upstream() {
  local func_name="${1}"
  if [[ ! -z "$(git branch -r | grep "$git_branch" | head -n 1 )" ]]; then
    read -rp "$func_name: no upstream branch: push --set-upstream origin ${git_branch}? [Y/n]" choice
    if [[ $choice = 'n' ]]; then
      return 1
    fi
    git push --set-upstream origin "$git_branch"
  fi
}

.ticket.pr.build() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"
  local jira_id="${1:-$(__spp_ticket_get_current)}"

  read -rp "$func_name: Do you want to tregger build for: ${jira_id}? [Y/n]" choice
  if [[ $choice = 'n' ]]; then
    return 1
  fi

  local git_project
  git_project="$(__spp_ticket_get_value "$jira_id" "$GIT_PROJECT")"

  local desc
  desc="$(__spp_ticket_get_value "$jira_id" "$DESC")"

  local git_branch
  git_branch="$(__spp_ticket_get_branch "$jira_id" "$desc")"

  read -rp "$func_name: Do you want to build: ${git_branch}? [Y/n]" choice
  if [[ $choice = 'n' ]]; then
    return 1
  fi

  __spp_ticket_git_check_upstream "$func_name"

  .jenkins.job "$git_project" "$git_branch"
}
alias .tpb=.ticket.build

.ticket.pr.create() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"

  local jira_id="${1:-$(__spp_ticket_get_current)}"

  local git_project
  git_project="$(__spp_ticket_get_value "$jira_id" "$GIT_PROJECT")"

  local desc
  desc="$(__spp_ticket_get_value "$jira_id" "$DESC")"

  local git_branch
  git_branch="$(__spp_ticket_get_branch "$jira_id" "$desc")"

  read -rp "$func_name: Do you want to create PR for: ${git_branch}? [Y/n]" choice
  if [[ $choice = 'n' ]]; then
    return 1
  fi

  __spp_ticket_git_check_upstream "$func_name"

  .github.pull "$git_project" "$git_branch" "$jira_id" "$desc"
}
alias .tpc=.ticket.pr.create

.ticket.pr.release() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"
  local jira_id="${1:-$(__spp_ticket_get_current)}"

  read -rp "$func_name: Do you want to release: ${jira_id}? [Y/n]" choice
  if [[ $choice = 'n' ]]; then
    return 1
  fi

  local git_project
  git_project="$(__spp_ticket_get_value "$jira_id" "$GIT_PROJECT")"

  .jenkins.job "$git_project" "master"
}
alias .tpr=.ticket.release


.ticket.info() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"
  __spp_ticket_info "${1-$(__spp_ticket_get_current)}"
}
alias .ti=.ticket.info

.ticket.ls() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"
  local option="${1-}"
  for ticket in "${SPP_TICKETS_PATH}"/*; do
    local jira_id
    jira_id=$(basename "$ticket")
    __spp_ticket_info "$jira_id" "$option"
  done
}
alias .tls=.ticket.ls

.ticket.switch() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"
  if [[ ${1-} = '-h' ]]; then
    echo "usage: $func_name [-h]"
    return 1
  fi

  local jira_id
  jira_id="$(.ticket.ls -p | fzf | awk '{ print $1 }')"
  if [[ ! -z $jira_id ]]; then
    __spp_ticket_set_current "$jira_id"
    .ticket.cd "$jira_id"
  fi
}
alias .ts=.ticket.switch


.ticket.done() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"

  local jira_id="${1:-$(__spp_ticket_get_current)}"

  read -rp "$func_name: Do you want to set: ${jira_id} as done? [Y/n]" choice
  if [[ $choice = 'n' ]]; then
    return 1
  fi

  # TODO: draw git release
  # TODO: merge ticket branch to master
  # TODO: set ticket as done in jira

  mv "${SPP_TICKETS_PATH}/${jira_id}" "${SPP_TICKETS_DONE_PATH}/${jira_id}"
}
alias .td=.ticket.done
