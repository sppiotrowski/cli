#!/usr/bin/env bash

# set -o nounset
# set -o pipefail
# set -o errexit
# set -o xtrace

export EDITOR=nvim
export BROWSER=chrome

export SPP_CLI_HOME="${HOME}/.spp/cli"
if [[ ! -d "$SPP_CLI_HOME" ]]; then
  mkdir -p "$SPP_CLI_HOME"
fi

export SPP_HOME="$HOME/_spp"
SRC="$SPP_HOME/src"

# shellcheck source=src/stats.sh
. "$SRC"/stats.sh

# shellcheck source=src/jira.sh
. "$SRC"/jira.sh

# shellcheck source=src/github.sh
. "$SRC"/github.sh

# shellcheck source=src/jenkins.sh
. "$SRC"/jenkins.sh

# shellcheck source=src/utils.sh
. "$SRC"/utils.sh

# shellcheck source=src/note.sh
. "$SRC"/note.sh

# shellcheck source=src/git.sh
. "$SRC"/git.sh

# shellcheck source=src/project.sh
. "$SRC"/project.sh

# shellcheck source=src/generate.sh
. "$SRC"/generate.sh

# shellcheck source=src/candidate.sh
# . "$SRC"/candidate.sh

.cli.backup() {
 cd "$SPP_HOME" && \
  git add .
  git commit -m "backup"
  git push origin master
}
