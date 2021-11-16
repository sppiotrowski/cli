#!/usr/bin/env bash

.git.project_name() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"

  git config --local --get remote.origin.url | sed -n 's/^.*\/\(.*\)\.git$/\1/p'
}

.git.current() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"

  git rev-parse --abbrev-ref HEAD
}

.git.upstream() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"

  git push --set-upstream origin "$(.git.current)"
}

.git.current.jira() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"

  .git.current | grep -o '^[A-Z]\+-[0-9]\+'
}

.git.prune() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"

  git fetch -p
  for branch in $(git branch | grep -v master | grep -v -e '^* '); do
    git branch -D "$branch"
  done
}

__spp_git_url() {
  git config --local --get remote.origin.url | sed -n 's/^git@\(.*\)\.git$/\1/p' | tr ':' '/'
}

.git.pull_request() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"

  open "https://$(__spp_git_url)/pull/new/$(.git.current)"
}

.git.open() {
  open "https://$(__spp_git_url)"
}

