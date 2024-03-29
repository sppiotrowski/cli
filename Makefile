SHELL := /usr/bin/env bash
lint:
	shellcheck -a -x *.sh

push:
	. ./cli.sh && .cli.backup

publish: lint push

install:
	@./bin/setup.sh

