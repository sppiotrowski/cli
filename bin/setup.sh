#! /usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
SPP="${HOME}/_spp"

if [ ! -d "$SPP" ]; then
  ln -s "$DIR" "${HOME}/_spp"
  echo 'spp: dir linked'
fi

if [ -z "$(grep _spp/cli.sh ~/.bashrc)" ]; then
  echo ". ${HOME}/_spp/cli.sh" >> "$HOME"/.bashrc
  echo 'spp: .bashrc updated'
fi

