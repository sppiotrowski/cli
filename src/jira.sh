#!/usr/bin/env bash

# Jira API token: https://id.atlassian.com/manage-profile/security/api-tokens
# echo 'SPP_JIRA_USER=me@example.com:my-api-token' >> ~/.bashrc
# echo 'SPP_JIRA_BASE_URL=https://example.atlassian.net' >> ~/.bashrc

# Jira API docs
# https://developer.atlassian.com/cloud/jira/platform/rest/v3/
# https://developer.atlassian.com/cloud/confluence/rest-api-examples/

SPP_JIRA_API='rest/api/3'

# use base64 to avoid sending user/token in plain text
__spp_jira_basic_auth() {
  echo -n "$SPP_JIRA_USER" | base64
}

.jira.issue() {
  local jira_id="$1"
  if [[ -z $jira_id ]]; then
    echo jira_id is missing
    return 1
  fi

SPP_JIRA_PARAM_FIELDS='fields=labels,components,summary,description,customfield_15141,customfield_10008'
# fields: key="ON-3008", labels=["frontend", "tech-debt"], components=[], summary, description,
# project.key="ON", project.name="Onsite Sales",
# issuetype.name issue.type="Task" priority.name="Major"
# status.name, created="2021-10-17T09:55:44.707+0200"
# coment.total, comment.comments=[]
# (Category) customfield_15141="Tech task
# (Epic Link) customfield_10008="ON-2700"
curl --request GET \
  --header "Authorization: Basic $(__spp_jira_basic_auth)" \
  --header "Content-Type: application/json" \
  --url "${SPP_JIRA_BASE_URL}/${SPP_JIRA_API}/issue/${jira_id}?${SPP_JIRA_PARAM_FIELDS}"
}
