SHELL := /usr/bin/env bash
lint:
	@echo shellcheck -a -x *.sh

push:
	. ./cli.sh && .cli.backup

publish: lint push

