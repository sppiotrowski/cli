# todo: simplify todo
# todo: backup it

export SPP_HOME=${HOME}/_spp

alias .date='echo $(date +%Y.%m.%d)'

.cli.backup() {
  cd "$SPP_HOME" && git commit -am "backup: $(.date)"
  cd -
}
.cli.todo() {
  #_note.add "$SPP_HOME/cli.sh" "todo" "$@"
  echo 'NOOP'
}
_note() {
  local file="$1"; shift
  local topic="$1"; shift
  local cmd="sed -n '/$topic/,/#/p' $file"
  eval "$cmd"
}

_note.edit() {
  local file="$1"; shift
  local topic="$1"; shift
  local cmd="vim +/$topic $file"
  eval "$cmd"
}

_note.add() {
  local file="$1"; shift
  local topic="$1"; shift
  local tail="$@"
  local cmd="echo '# $topic' >> $file"
  eval "$cmd"
  local cmd_tail="echo '$tail' >> $file"
  eval "$cmd_tail"
}

HOWTO_FILE=${SPP_HOME}/howto.txt
.howto() {
  _note "$HOWTO_FILE" "$@"
}
.howto.edit() {
  _note.edit "$HOWTO_FILE" "$@"
}
.howto.add() {
  _note.add "$HOWTO_FILE" "$@"
}
