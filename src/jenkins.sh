#!/usr/bin/env bash

# Jenkins API token: https://www.jenkins.io/blog/2018/07/02/new-api-token-system
# echo 'SPP_JENKINS_USER=me:my-api-token' >> ~/.bashrc
# echo 'SPP_JENKINS_BASE_URL=https://example.jenkins.com' >> ~/.bashrc

# Jenkins API docs
# https://www.jenkins.io/doc/book/using/remote-access-api/

.jenkins.open() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"

  if [[ $1 = '-h' ]]; then
    echo "usage: $func_name [-h] git_project"
    return 1
  fi

  local git_project="${1-$(.git.project_name)}"

  open "${SPP_JENKINS_BASE_URL}/job/docker%20builds/job/build%20${git_project}%20image/"
}
alias .jeo=.jenkins.open

.jenkins.build() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"

  if [[ $1 = '-h' ]]; then
    echo "usage: $func_name [-h] git_project git_branch"
    return 1
  fi

  local git_project="${1-$(.git.project_name)}"
  if [[ -z $git_project ]]; then
    echo "$func_name" git_project is missing
    return 1
  fi

  local git_branch="${2-$(.git.current)}"
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
alias .jeb=.jenkins.build

.jenkins.build_open() {
  .jenkins.build && .jenkins.open
}
alias .jebo=.jenkins.build_open
