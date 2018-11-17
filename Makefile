SHELL := /usr/bin/env bash
lint:
	shellcheck -a -x *.sh src/*.sh

push:
	. ./cli.sh && .cli.backup

publish: lint push

