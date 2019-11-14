#!/usr/bin/env bash

eval "$(pyenv init -)"

PY2VER=2.7.16
PY3VER=3.7.4

# install python
pyenv install ${PY2VER}

# set up pyenv environments
pyenv virtualenv ${PY2VER} ipython${PY2VER}
pyenv virtualenv ${PY2VER} tools${PY2VER}

# set up ipython2 environment
pyenv activate ipython${PY2VER}
pip install ipykernel
python -m ipykernel install --user
pyenv deactivate

# set up tools2 environment
pyenv activate tools${PY2VER}
pip install rst2pdf powerline-status
pyenv deactivate

# set the global pyenv shim path
pyenv global ${PY3VER} ${PY2VER} \
	jupyter${PY3VER} ipython${PY2VER} \
	tools${PY3VER} tools${PY2VER}
