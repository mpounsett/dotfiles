#!/usr/bin/env bash

# See
# <https://medium.com/@henriquebastos/the-definitive-guide-to-setup-my-python-workspace-628d68552e14>
# for an excellent example of how to make use of this setup.

PY3VER=3.7.4
PY2VER=2.7.16

echo << END
Make sure you get all the libraries you need!
gcc g++ make zlib1g-dev libbz2-dev libreadline-dev libssl-dev libsqlite3-dev libffi-dev
END

# Check for requirements
which gcc || exit 
which cc1plus || exit
which make || exit

read -p "?Press a key to continue or ^c to quit "

PYENV_ROOT=~/.pyenv

# pyenv install
git clone https://github.com/pyenv/pyenv.git ${PYENV_ROOT}
git clone https://github.com/pyenv/pyenv-virtualenv.git ${PYENV_ROOT}/plugins/pyenv-virtualenv
git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git ${PYENV_ROOT}/plugins/pyenv-virtualenvwrapper

# working directory to keep Virtual Environment data

# initial setup of pyenv
export WORKON_HOME=~/.ve
mkdir ${WORKON_HOME}

export PATH=${PYENV_ROOT}/bin:${PATH}
eval "$(pyenv init -)"

# cat - <<'END' >> ~/.bashrc
# export WORKON_HOME=~/.ve
# export PROJECT_HOME=~/workspace
# export PYENV_ROOT=~/.pyenv
# export PATH=${PYENV_ROOT}/bin:${PATH}
# eval "$(pyenv init -)"
# pyenv virtualenvwrapper_lazy
# END
