#!/usr/bin/env bash

set -euxo pipefail

PYENV_ROOT=~/.pyenv
export PATH=${PYENV_ROOT}/bin:${PATH}
eval "$(pyenv init -)"

PY2VER="2.7.17"
PY3VER="3.8.0"
PY3OLDVER="3.7.4 3.6.9 3.5.7 3.4.10 3.3.7 3.2.6"

# install python
pyenv install ${PY3VER}

# set up pyenv environments
pyenv virtualenv ${PY3VER} jupyter${PY3VER}
pyenv virtualenv ${PY3VER} tools${PY3VER}

# set up Jupiter3 environment
pyenv activate jupyter${PY3VER}
pip install jupyter ipython notebook
python -m ipykernel install --user \
	--name jupyter${PY3VER} --display-name "Python ${PY3VER}"
pyenv deactivate

# set up tools3 environment
pyenv activate tools${PY3VER}
pip install flake8 pdf-diff3 powerline-status restview xml2rfc
pyenv deactivate

# set the global pyenv shim path
pyenv global ${PY3VER} ${PY3OLDVER} ${PY2VER} \
	jupyter${PY3VER} ipython${PY2VER} \
	tools${PY3VER} tools${PY2VER} system
