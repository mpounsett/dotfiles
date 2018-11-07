#!/usr/bin/env bash

# See
# <https://medium.com/@henriquebastos/the-definitive-guide-to-setup-my-python-workspace-628d68552e14>
# for an excellent example of how to make use of this setup.

echo << END
Make sure you get all the libraries you need!
gcc make zlib1g-dev libbz2-dev libreadline-dev libssl-dev libsqlite3-dev
END

# Check for requirements
which gcc || exit 
which make || exit

read -q "?Press a key to continue or ^c to quit "

PYENV_ROOT=~/.pyenv

# pyenv install
git clone https://github.com/pyenv/pyenv.git ${PYENV_ROOT}
git clone https://github.com/pyenv/pyenv-virtualenv.git ${PYENV_ROOT}/plugins/pyenv-virtualenv
git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git ${PYENV_ROOT}/plugins/pyenv-virtualenvwrapper

# working directory to keep Virtual Environment data

# initial setup of pyenv
export WORKON_HOME=~/.ve
mkdir ${WORKON_HOME}
export PROJECT_HOME=~/workspace
mkdir ${PROJECT_HOME}

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

#  install pythons
pyenv install 3.6.5 
pyenv install 2.7.15

# set up pyenv environments
pyenv virtualenv 3.6.5 jupyter3
pyenv virtualenv 3.6.5 tools3
pyenv virtualenv 2.7.15 ipython2
pyenv virtualenv 2.7.15 tools2

# set up Jupiter3 environment
pyenv activate jupyter3
pip install jupyter
python -m ipykernel install --user
pyenv deactivate

# set up ipython2 environment
pyenv activate ipython2
pip install ipykernel
python -m ipykernel install --user
pyenv deactivate

# set up tools3 environment
pyenv activate tools3
pip install pdf-diff3 flake8 powerline-status xml2rfc
pyenv deactivate

# set up tools2 environment
pyenv activate tools2
pip install rst2pdf powerline-status
pyenv deactivate

# set the global pyenv shim path
pyenv global 3.6.5 2.7.15 jupyter3 ipython2 tools3 tools2
