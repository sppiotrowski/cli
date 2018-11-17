#!/usr/bin/env bash

.git.current() {
    git rev-parse --abbrev-ref HEAD
}

.git.current.jira() {
    echo $(.git.current) | grep -o '^[A-Z]\+-[0-9]\+'
}
