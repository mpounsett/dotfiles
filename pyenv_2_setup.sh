#!/usr/bin/env bash

eval "$(pyenv init -)"

PY2VER=2.7.16
PY3VER=3.7.4

# set up pyenv environments
pyenv virtualenv ${PY2VER} ipython2
pyenv virtualenv ${PY2VER} tools2

# set up ipython2 environment
pyenv activate ipython2
pip install ipykernel
python -m ipykernel install --user
pyenv deactivate

# set up tools2 environment
pyenv activate tools2
pip install rst2pdf powerline-status
pyenv deactivate

# set the global pyenv shim path
pyenv global ${PY3VER} ${PY2VER} jupyter3 ipython2 tools3 tools2
