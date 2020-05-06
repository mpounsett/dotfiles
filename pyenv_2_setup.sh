#!/usr/bin/env bash

set -euxo pipefail

PYENV_ROOT=~/.pyenv
export PATH=${PYENV_ROOT}/bin:${PATH}
eval "$(pyenv init -)"

PY2VER="2.7.17"
PY3VER="3.8.0"
PY3OLDVER="3.7.4 3.6.9 3.5.7 3.4.10 3.3.7 3.2.6"

# install python
pyenv install ${PY2VER}

# set up pyenv environments
pyenv virtualenv ${PY2VER} ipython${PY2VER}
pyenv virtualenv ${PY2VER} tools${PY2VER}

# set up ipython2 environment
pyenv activate ipython${PY2VER}
pip install python ipykernel notebook
python -m ipykernel install --user \
	--name ipython${PY2VER} --display-name "Python ${PY2VER}"
pyenv deactivate

# set up tools2 environment
pyenv activate tools${PY2VER}
pip install rst2pdf powerline-status
pyenv deactivate

# set the global pyenv shim path
pyenv global ${PY3VER} ${PY3OLDVER} ${PY2VER} \
	jupyter${PY3VER} ipython${PY2VER} \
	tools${PY3VER} tools${PY2VER} system
