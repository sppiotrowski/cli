#!/usr/bin/env bash

TICKET_FILE="$HOME/.ticket"
REQUESTS="$HOME/projects/cli/src/requests-polite.txt"
EMOJIS="$HOME/projects/cli/src/emoji-polite.txt"
MORNING_EMOJI="/Users/spi/projects/cli/src/emoji-morning.txt"
MORNING_WISHES="/Users/spi/projects/cli/src/morning.txt"

.morning() {
  local emoji
  emoji=$(gshuf "$MORNING_EMOJI" | head -n 1 | tr -d '\n')
  local wish
  wish=$(gshuf "$MORNING_WISHES" | head -n 1 | tr -d '\n')
  local msg="${wish} ${emoji}"
  tr -d '\n' <<< "$msg" | pbcopy
  echo "$msg"
}
alias .m=.morning

.ticket.clear() {
  rm "$TICKET_FILE"
}

.ticket.set() {
  local ticket="${1}"
  if [ -z "$ticket" ]; then
    echo "the ticked id is missing"
    exit 2
  fi

  local ticket_id="${ticket##*/}"
  local ticket_desc="${*:2}"
  local ticket_branch="${ticket_id}_${ticket_desc// /_}"

  echo "$ticket_id" > "$TICKET_FILE"
  echo "$ticket" >> "$TICKET_FILE"
  echo "$ticket_branch" >> "$TICKET_FILE"

  local ask
  ask=$(gshuf "$REQUESTS" | head -n 1)
  local emoji
  emoji=$(gshuf "$EMOJIS" | head -n 1)
  echo "${emoji} PR to [${ticket_desc}](${ticket}). ${ask}" >> "$TICKET_FILE"
}

alias .ts=.ticket.set

.ticket.get() {
  local ticket
  ticket="$(< "$TICKET_FILE")"
  tr -d '\n' <<< "$ticket" | pbcopy
  echo -n "$ticket"
}
alias .t=.ticket.get
