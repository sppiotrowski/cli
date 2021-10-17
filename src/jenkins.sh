#!/usr/bin/env bash

# Jenkins API token: https://www.jenkins.io/blog/2018/07/02/new-api-token-system
# echo 'SPP_JENKINS_USER=me:my-api-token' >> ~/.bashrc
# echo 'SPP_JENKINS_BASE_URL=https://example.jenkins.com' >> ~/.bashrc

# Jira API docs
# https://www.jenkins.io/doc/book/using/remote-access-api/

.jenkins.job() {
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

  local job_name="build%20${git_project}%20image"

  curl --request POST \
    --user "$SPP_JENKINS_USER" \
    --url "${SPP_JENKINS_BASE_URL}/job/docker%20builds/job/${job_name}/buildWithParameters" \
    --data branch="$git_branch"
}
