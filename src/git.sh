#!/usr/bin/env bash

.git.current() {
  git rev-parse --abbrev-ref HEAD
}

.git.current.jira() {
    .git.current | grep -o '^[A-Z]\+-[0-9]\+'
}

.jira() {
  local ticket
  ticket="${1:-$(.git.current.jira)}"
  open "https://outfittery.atlassian.net/browse/$ticket"
}

.git.prune() {
  git fetch -p
  for branch in $(git branch | grep -v master | grep -v -e '^* '); do
    git branch -D "$branch"
  done
}

_git_config_url() {
  git config --local remote.origin.url
}

_git_url() {
  _git_config_url | awk -F@ '{print $2}' | sed -e 's/.git//' -e 's/:/\//'
}

.git.pull_request() {
  open "https://$(_git_url)/pull/new/$(.git.current)"
}

.git.project_name() {
  _git_url | awk -F'/' '{ print $3 }'
}

.git.open() {
  open "https://$(_git_url)"
}

