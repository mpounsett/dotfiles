#!/usr/bin/env bash

PYENV_ROOT=~/.pyenv

for dir in 	${PYENV_ROOT} \
			${PYENV_ROOT}/plugins/pyenv-virtualenv\
			${PYENV_ROOT}/plugins/pyenv-virtualenvwrapper; do
	cd ${dir}
	git pull --rebase
done

