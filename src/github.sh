#!/usr/bin/env bash

# API token: https://github.com/settings/tokens/new
# echo 'SPP_GITHUB_API_TOKEN='****' >> ~/.bashrc
# echo 'SPP_GITHUB_OWNER='owner' >> ~/.bashrc
# echo 'SPP_GITHUB_BASE_URL='https://api.github.com' >> ~/.bashrc

# API docs
# https://docs.github.com/en/rest/reference/pulls

.github.pull() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"
  if [[ $1 = '-h' ]]; then
    echo "usage: $func_name [-h] git_project_name git_branch_name"
    return 1
  fi

  local git_project="$1"
  if [[ -z $git_project ]]; then
    echo "$func_name" git_project is missing
    return 1
  fi

  local git_branch="$2"
  if [[ -z $git_branch ]]; then
    echo "$func_name" git_branch is missing
    return 1
  fi

  local jira_id="$3"
  if [[ -z $jira_id ]]; then
    echo "$func_name" jira_id is missing
    return 1
  fi

  local desc="${*:4}"
  if [[ -z $desc ]]; then
    echo "$func_name" desc is missing
    return 1
  fi

  local title="$jira_id - $desc"

  local body
  body=$(cat <<EOF
[$jira_id](${SPP_JIRA_BASE_URL}/browse/${jira_id}) 👷 Work in progress...
EOF
)

  local data
  data=$(cat <<EOF
{ "head":"$git_branch","base":"master","title":"$title","draft":true,"body":"$body" }
EOF
  )

  # TODO: read from curl output
  # | grep html_url | awk -F'": "|",' '{print $2}'

  curl --silent \
    --request POST \
    --header "Authorization: token ${SPP_GITHUB_API_TOKEN}" \
    --header "Accept: application/vnd.github.v3+json" \
    --url "${SPP_GITHUB_BASE_URL}/repos/${SPP_GITHUB_OWNER}/${git_project}/pulls" \
    --data "$data"
}
