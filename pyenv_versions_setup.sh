#!/usr/bin/env zsh
# vim:expandtab:ts=2

# set -euxo pipefail
set -uo pipefail

PYENV_ROOT=~/.pyenv
export PATH=${PYENV_ROOT}/bin:${PATH}
eval "$(pyenv init -)"

PY2VER=(2.7.18)
PY3VER=(3.14.0 3.13.8 3.12.12 3.11.14 3.10.19 3.9.24 3.8.20 3.7.17 3.6.15)

PY2_CURRENT=2.7.18
PY3_CURRENT=3.14.0
PY3_TOOLS=3.14.0

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
pyenv shell jupyter${PY3_TOOLS} || exit "Failed to open jupyter shell"
pip install jupyter ipython notebook
python -m ipykernel install --user \
  --name jupyter${PY3_TOOLS} --display-name "Python ${PY3_TOOLS}"
pyenv shell --unset

# set up tools3 environment
pyenv shell tools${PY3_TOOLS} || exit "Failed to open tools shell"
pip install flake8 powerline-status restview rst2pdf xml2rfc \
  linkchecker
pyenv shell --unset

# set the global pyenv shim path
pyenv global ${PY3VER} ${PY2VER} \
  jupyter${PY3_TOOLS} tools${PY3_TOOLS} \
  system

pip install --upgrade virtualenvwrapper
