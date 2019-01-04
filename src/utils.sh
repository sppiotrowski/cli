#!/usr/bin/env bash

.util.date() {
  date +%Y.%m.%d | tee /dev/tty | pbcopy
}

.util.thinker() {
  echo "🤔" | tee /dev/tty | pbcopy
}
alias .thinker='.util.thinker'

.util.email() {
  echo "spp.$(date +%Y.%m.%d.%H.%M)@test.de" | tee /dev/tty | pbcopy
}

.util.replace() {
  KEY="$1"; shift
  VAL="$1"; shift
  FILE="$*"
  sed -i '' -e  s/"${KEY}"/"${VAL}"/ "$FILE"
}
