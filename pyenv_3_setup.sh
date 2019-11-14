#!/usr/bin/env bash

eval "$(pyenv init -)"

PY2VER=2.7.16
PY3VER=3.7.4

# install python
pyenv install ${PY3VER}

# set up pyenv environments
pyenv virtualenv ${PY3VER} jupyter${PY3VER}
pyenv virtualenv ${PY3VER} tools${PY3VER}

# set up Jupiter3 environment
pyenv activate jupyter${PY3VER}
pip install jupyter
python -m ipykernel install --user
pyenv deactivate

# set up tools3 environment
pyenv activate tools${PY3VER}
pip install flake8 pdf-diff3 powerline-status restview xml2rfc
pyenv deactivate

# set the global pyenv shim path
pyenv global ${PY3VER} ${PY2VER} \
	jupyter${PY3VER} ipython${PY2VER} \
	tools${PY3VER} tools${PY2VER}
