#!/usr/bin/env bash

# Jira API token: https://id.atlassian.com/manage-profile/security/api-tokens
# echo 'SPP_JIRA_USER=me@example.com:my-api-token' >> ~/.bashrc
# echo 'SPP_JIRA_BASE_URL=https://example.atlassian.net' >> ~/.bashrc

# Jira API docs
# https://developer.atlassian.com/cloud/jira/platform/rest/v3/
# https://developer.atlassian.com/cloud/confluence/rest-api-examples/

SPP_JIRA_API='rest/api/3'

# response: {key: "ON-3008", fields: {}}

# fields
# coment: {total: '0', comments: []}
# components: [{name: "demand-funnels"}]
# created="2021-10-17T09:55:44.707+0200"
# customfield_10008: "ON-2700"   # Epic
# customfield_15141: "Tech task  # Category
# description: {complex object} # TODO: how to read
# issuetype: {name: "Task"}
# labels: ["frontend", "tech-debt"]
# priority: {name: "Major"}
# project: {key:"ON", name:"Onsite Sales"}
# status: {name: "To Do"}
# summary: "Fix demand-funnels hooks"

SPP_JIRA_PARAM_FIELDS="fields=$(
cat <<EOF | tr '\n' ','
comment
components
created
customfield_10008
customfield_15141
description
issue
issuetype
labels
priority
project
status
summary
EOF
)"

# json_pp -json_opt pretty,canonical

# use base64 to avoid sending user/token in plain text
__spp_jira_basic_auth() {
  echo -n "$SPP_JIRA_USER" | base64
}

__spp_jira_issue() {
  local jira_id="$1"
  if [[ -z $jira_id ]]; then
    echo jira_id is missing
    return 1
  fi

  curl --silent --show-error \
    --request GET \
    --header "Authorization: Basic $(__spp_jira_basic_auth)" \
    --header "Content-Type: application/json" \
    --url "${SPP_JIRA_BASE_URL}/${SPP_JIRA_API}/issue/${jira_id}?${SPP_JIRA_PARAM_FIELDS}"
}

.jira.get() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"

  if [[ $1 = '-h' ]]; then
    echo "usage: $func_name [-h] jira_id"
    return 1
  fi

  local jira_id="${1-$(.git.current.jira)}"

  read -r -d '' CMD <<EOF
import json,sys
issue = json.load(sys.stdin)
key = issue['key']
summary = issue['fields']['summary']
components = list(map(lambda component: component['name'], issue['fields']['components']))
labels = issue['fields']['labels']
print(key, components[0], summary)
EOF
  __spp_jira_issue "$jira_id" | python3 -c "$CMD"
}

.jira.open() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"

  if [[ $1 = '-h' ]]; then
    echo "usage: $func_name [-h] jira_id"
    return 1
  fi

  local jira_id="${1-$(.git.current.jira)}"

  open "${SPP_JIRA_BASE_URL}/browse/${jira_id}"
}
alias .jira=.jira.open
