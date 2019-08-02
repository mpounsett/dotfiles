#!/usr/bin/env bash

eval "$(pyenv init -)"

PY2VER=2.7.16
PY3VER=3.7.4

# set up pyenv environments
pyenv virtualenv ${PY3VER} jupyter3
pyenv virtualenv ${PY3VER} tools3

# set up Jupiter3 environment
pyenv activate jupyter3
pip install jupyter
python -m ipykernel install --user
pyenv deactivate

# set up tools3 environment
pyenv activate tools3
pip install flake8 pdf-diff3 powerline-status restview xml2rfc
pyenv deactivate

# set the global pyenv shim path
pyenv global ${PY3VER} ${PY2VER} jupyter3 ipython2 tools3 tools2
