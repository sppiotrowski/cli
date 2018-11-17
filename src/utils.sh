#!/usr/bin/env bash

alias .util.date='echo $(date +%Y.%m.%d) | tee /dev/tty | pbcopy'
alias .yay='echo "Yippee-Ki-Yay…" | tee /dev/tty | pbcopy'

.util.email() {
  echo "spp.$(date +%Y.%m.%d.%H.%M)@test.de" | tee /dev/tty | pbcopy
}
.util.replace() {
  KEY="$1"; shift
  VAL="$1"; shift
  FILE="$*"
  sed -i '' -e  s/"${KEY}"/"${VAL}"/ "$FILE"
}
