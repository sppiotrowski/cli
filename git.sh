#!/usr/bin/env bash

.git.current() {
    git rev-parse --abbrev-ref HEAD
}

.git.current.jira() {
    .git.current | grep -o '^[A-Z]\+-[0-9]\+'
}

.jira() {
  open "https://outfittery.atlassian.net/browse/$(.git.current.jira)"
}

.git.prune() {
  git fetch -p
  for branch in $(git branch | grep -v master | grep -v -e '^* '); do
    git branch -D "$branch"
  done
}

_git_url() {
  grep url ./.git/config | awk -F@ '{print $2}' | sed -e 's/.git//' -e 's/:/\//'
}

.git.pr() {
  open "https://$(_git_url)/pull/new/$(.git.current)"
}

.git.open() {
  open "https://$(_git_url)"
}

.git.recreate() {
    local proj
    proj=$(.pr.current)
    local repo
    repo=$(grep url .git/config | awk -F' = ' '{ print $2 }')
    if [ -z "$proj" ] || [ -z "$repo" ]; then
        echo 'ups...'
        return 1
    fi
    read -p "rm -rf $proj? [N/y]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        cd ..
        rm -rf "./$proj"
        git clone "$repo"
        cd "./$proj" || return
    fi
}

