#!/usr/bin/env bash

# TODO: errors from other scripts?!
# set -o errexit
# set -o nounset
# set -o pipefail
# set -o xtrace

SPP_STATS_FILE="${SPP_CLI_HOME}/stats"

__spp_stat() {
  # TODO: clar all callres
  # local function_name="$1"
  local function_name="$funcstack[-1]"
  echo "$function_name" "$(date +%Y.%m.%dT%H:%M:%S)" >> "$SPP_STATS_FILE"
}

.stats() {
  __spp_stat "${FUNCNAME[0]}"
  awk '{print $1}' "$SPP_STATS_FILE" | sort | uniq -c | sort -r -n
}

.stats.clear() {
  __spp_stat "${FUNCNAME[0]}"
  rm "$SPP_STATS_FILE"
}

