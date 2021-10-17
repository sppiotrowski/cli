#!/usr/bin/env bash

set -o nounset
set -o pipefail
set -o errexit
# set -o xtrace

# TODO: change naming
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__file_basename="$(basename "${__file}" .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

SPP_TEMPLATE_VAR='template'

# shellcheck source=./stats.sh
. "${__dir}/stats.sh"

.test.foo() {
  local func_name="${FUNCNAME[0]}"
  __spp_stat "$func_name"
  if [[ $1 = '-h' ]]; then
    echo "usage: $func_name [-h] test_param"
    return 1
  fi

  arg1="${1:-}"

  echo "__dir: ${__dir}"
  echo "__file: ${__file}"
  echo "__file_basename: ${__file_basename}"
  echo "__root: ${__root}"
  echo "${SPP_TEMPLATE_VAR}: ${arg1}"
}

.test.foo my-param

