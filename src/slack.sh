#!/usr/bin/env bash

# Slack API token: https://api.slack.com/apps/
# echo 'SPP_SLACK_USER=me:my-api-token' >> ~/.bashrc
# echo 'SPP_SLACK_BASE_URL=https://example.slack.com' >> ~/.bashrc

# API docs
# https://api.slack.com/methods/chat.postMessage as_user=true
# generate token https://api.slack.com/methods/oauth.access  chat:write:user

.slack.msg() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"
  if [[ $1 = '-h' ]]; then
    echo "usage: $func_name [-h] "
    return 1
  fi

  local msg="$1"
  if [[ -z $msg ]]; then
    echo "$msg" git_project is missing
    return 1
  fi

  curl --request POST \
    --user "$SPP_SLACK_USER" \
    --url "${SPP_SLACK_BASE_URL}/"
}
