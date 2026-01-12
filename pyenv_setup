#!/usr/bin/env zsh
# vim:autoindent:expandtab:sw=2:ts=2

# See
# <https://medium.com/@henriquebastos/the-definitive-guide-to-setup-my-python-workspace-628d68552e14>
# for an excellent example of how to make use of this setup.

CHECK_BINARIES=(gcc make)
PYENV_ROOT=~/.pyenv

cat << END
Make sure you get all the libraries you need!

   g++ gcc libbz2-dev libffi-dev liblzma-dev libreadline-dev libsqlite3-dev
   libssl-dev make zlib1g-dev

END

read "?Press a key to continue or ^c to quit "

# look for some basic binaries that should be there for building python, as a
# last-ditch santify check
for binary in $CHECK_BINARIES; do
  which ${binary} 2>&1 > /dev/null
  if [[ $? -ne 0 ]]; then
    echo "${binary} not found in path"
    exit 1
  fi
done

# pyenv install
if [[ ! -d ${PYENV_ROOT} ]]; then
  git clone https://github.com/pyenv/pyenv.git ${PYENV_ROOT}
  git clone https://github.com/pyenv/pyenv-virtualenv.git ${PYENV_ROOT}/plugins/pyenv-virtualenv
  git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git ${PYENV_ROOT}/plugins/pyenv-virtualenvwrapper
else
  echo "${PYENV_ROOT} already exists.  Not downloading new pyenv install."
fi

# working directory to keep Virtual Environment data

# initial setup of pyenv
export WORKON_HOME=~/.ve
if [[ ! -d "${WORKON_HOME}" ]]; then
  mkdir -f "${WORKON_HOME}"
fi

export PATH=${PYENV_ROOT}/bin:${PATH}
eval "$(pyenv init -)"

