alias vim='mvim -v'
alias ll='ls -al'
alias .date='echo $(date +%Y.%m.%d) | tee /dev/tty | pbcopy'
alias .yippekiyay='echo "Yippee-Ki-Yay…" | tee /dev/tty | pbcopy'

.user() {
  echo "spp.$(date +%Y.%m.%d.%H.%M)@test.de" | tee /dev/tty | pbcopy
}

export TODO=${HOME}/todo.md
.todo() {
  echo "$*" >> "$TODO"
}

.todo.get() {
  cat "$TODO"
}

.history() {
  history | sed 's/^[ ]*[0-9]* //' | sort | uniq
}
.replace() {
  KEY="$1"; shift
  VAL="$1"; shift
  FILE="$*"
  sed -i '' -e  s/"${KEY}"/"${VAL}"/ "$FILE"
}

.hart() {
  echo ♡  | tee /dev/tty | pbcopy
}

.log() {
    # vim "$HOME/log.markdown" "$HOME/howto.markdown"
    vim "$HOME/howto.markdown"
}

.pr.current() {
  local projects_path="${PWD#*projects\/}"
  local current=$(cut -d'/' -f1 <<< "$projects_path")
  if [ "$current" == '.' ]; then
    echo $(basename $PWD)
  else
    echo $current
  fi
}

.pr() {
    APP_PART="$1"

    if [ -z "$APP_PART" ]; then
        return 1
    fi
    APP_NAME="$(ls -d ${HOME}/projects/*${APP_PART}* | xargs basename)"
    
    echo "$APP_NAME"
}

.github() {
    APP_PART="${1:-$(.pr.current)}"
    APP_NAME="$(.pr $APP_PART)"
    open "https://github.com/paulsecret/${APP_NAME}"
}

.ci() {
    APP_PART="${1:-$(.pr.current)}"
    APP_NAME="$(.pr $APP_PART)"
    #open "http://ci-2.dev.outfittery.de/search/?q=${APP_NAME} image"
    open "http://ci-2.dev.outfittery.de/job/build%20${APP_NAME}%20image/"
}
alias .jenkins=.ci

.git.clone() {
    PROJECT="$1"
    (cd "$PROJECTS_PATH" && git clone "git@github.com:paulsecret/${PROJECT}.git")
}

.jira() {
    JIRA_TICKET="${1:-$(.git.current.jira)}"
    open "https://outfittery.atlassian.net/browse/${JIRA_TICKET}"
}

PROJECTS_PATH="${HOME}/projects"

_cd_complete() {
  # http://www.linuxjournal.com/content/more-using-bash-complete-command

  local cmd="${1##*/}"
  local word=${COMP_WORDS[COMP_CWORD]}
  local line=${COMP_LINE}
   if [ -z "$word" ]; then
     COMPREPLY=($(ls -d "${PROJECTS_PATH}"/* | xargs basename | sed -e 's/^ps-app-//g' -e 's/^ps-//g'))
   else
     COMPREPLY=($(ls -d "${PROJECTS_PATH}"/*${word}* 2>/dev/null | xargs basename | sed -e 's/^ps-app-//g' -e 's/^ps-//g'))
   fi
}

.cd() {
    APP_PART="$1"

    if [ -z "$APP_PART" ]; then
        cd "$PROJECTS_PATH"
        return 1
    fi

    
        
    DIR=("${PROJECTS_PATH}/*${APP_PART}")
    #ls -d $DIR 2>/dev/null | wc -l
    cd $DIR
}
complete -F _cd_complete .cd


.salt() {
  echo "$(ssh stage-salt salt $*)"
}

.salt.prod() {
  echo "$(ssh prod-salt salt $*)"
}

.exec() {
  LINE_NO=$1

  if [ ! "$LINE_NO" ]; then
    return 1
  fi

  CMD="$(sed -n "${LINE_NO}p" "$HOME"/log.markdown)"
  read -r -p "exec: ${CMD}? [Y/n]" response
  case "$response" in
      [nN])
          return 0
          ;;
      *)
          eval "$CMD"
          ;;
  esac
}

