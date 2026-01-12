#!/usr/bin/env bash
# vim:autoindent:expandtab:sw=2:ts=2

if [[ -x "${HOME}/.pyenv/bin/pyenv" ]]; then
  PYENV_ROOT=~/.pyenv
  for dir in  ${PYENV_ROOT} \
    ${PYENV_ROOT}/plugins/pyenv-virtualenv\
    ${PYENV_ROOT}/plugins/pyenv-virtualenvwrapper; do
      cd ${dir}
      git pull --rebase
  done
fi
