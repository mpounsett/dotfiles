#!/usr/bin/env zsh

# set -euxo pipefail
set -uxo pipefail

PYENV_ROOT=~/.pyenv
export PATH=${PYENV_ROOT}/bin:${PATH}
eval "$(pyenv init -)"

PY2VER=(2.7.18)
PY3VER=(3.12.4 3.11.9 3.10.14 3.9.19 3.8.19 3.7.17 3.6.15)

PY2_CURRENT=2.7.18
PY3_CURRENT=3.12.4
PY3_TOOLS=3.11.9

for VER in $PY2VER $PY3VER; do
	echo "========================"
	echo "Installing Python ${VER}"
	echo "========================"
	pyenv install ${VER}
done

# set up pyenv environments
pyenv virtualenv ${PY3_TOOLS} jupyter${PY3_TOOLS}
pyenv virtualenv ${PY3_TOOLS} tools${PY3_TOOLS}

# set up Jupiter3 environment
# pyenv activate jupyter${PY3_CURRENT}
# pip install jupyter ipython notebook
# python -m ipykernel install --user \
	# --name jupyter${PY3_CURRENT} --display-name "Python ${PY3_CURRENT}"
# pyenv deactivate

# set up tools3 environment
# pyenv activate tools${PY3_CURRENT}
# pip install flake8 pdf-diff3 powerline-status restview rst2pdf xml2rfc linkchecker
# pyenv deactivate

# set the global pyenv shim path
pyenv global ${PY3VER} ${PY2VER} \
	jupyter${PY3_TOOLS} tools${PY3_TOOLS} \
	system
