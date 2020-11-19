#!/usr/bin/env bash

# See
# <https://medium.com/@henriquebastos/the-definitive-guide-to-setup-my-python-workspace-628d68552e14>
# for an excellent example of how to make use of this setup.

echo << END
Make sure you get all the libraries you need!
g++ gcc libbz2-dev libffi-dev liblzma-dev libreadline-dev libsqlite3-dev libssl-dev make zlib1g-dev
END

# Check for requirements
which gcc || exit 
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

