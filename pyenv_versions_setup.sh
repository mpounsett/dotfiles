#!/usr/bin/env zsh
# vim:expandtab:ts=2:sw=2

###########################
### CONFIGURATION VARIABLES

# The python version to use for tools and jupyter environments
PY3_TOOLS=3.14.0

# Packages to install in each environment
JUPYTER_PACKAGES=(jupyter ipython notebook)
TOOLS_PACKAGES=(ansible flake8 restview rst2pdf xml2rfc linkchecker)

# The low and high Python 3 minor versions to install
# '10' for 3.10, 11 for 3.11, etc.
PY3_LOW_MINOR=6
PY3_HIGH_MINOR=14


### END OF CONFIGURATION
###########################

# set -euxo pipefail
set -uo pipefail

PYENV_ROOT=~/.pyenv
export PATH=${PYENV_ROOT}/bin:${PATH}
eval "$(pyenv init -)"

PY2VER=(2.7.18)
PY3VER=("${(@f)$(
  for (( minor=PY3_LOW_MINOR; minor<=PY3_HIGH_MINOR; minor++ )); do
    pyenv install -l |
      grep -oE "3\.${minor}\.[0-9]+$" |        # emit only the version, no leading spaces
      sort -t . -k3,3n | tail -1
  done | sort -t . -k2,2rn
)}")

JUPYTER_ENV="jupyter${PY3_TOOLS}"
TOOLS_ENV="tools${PY3_TOOLS}"

INSTALLED=($(pyenv version --bare))

for VER in $PY2VER $PY3VER; do
  if [[ "${INSTALLED[(i)${VER}]}" -gt ${#INSTALLED} ]]; then
    echo "========================"
    echo "Installing Python ${VER}"
    echo "========================"
    pyenv install ${VER}
  fi
done

# set up Jupiter3 environment
if [[ "${INSTALLED[(i)${JUPYTER_ENV}]}" -gt ${#INSTALLED} ]]; then
  pyenv virtualenv "${PY3_TOOLS}" "${JUPYTER_ENV}"
fi

print "\n===== Updating ${JUPYTER_ENV} setup.\n\n"
pyenv shell "${JUPYTER_ENV}" || exit "Failed to open jupyter shell"
pip install ${JUPYTER_PACKAGES}
python -m ipykernel install --user \
  --name "${JUPYTER_ENV}" --display-name "Python ${PY3_TOOLS}"
pyenv shell --unset

# set up tools3 environment
if [[ "${INSTALLED[(i)${TOOLS_ENV}]}" -gt ${#INSTALLED} ]]; then
  pyenv virtualenv "${PY3_TOOLS}" "${TOOLS_ENV}"
fi

print "\n===== Updating ${TOOLS_ENV} setup.\n\n"
pyenv shell "${TOOLS_ENV}" || exit "Failed to open tools shell"
pip install ${TOOLS_PACKAGES}
pyenv shell --unset

# set the global pyenv shim path
print "\n===== Setting global Python version list.\n\n"
pyenv global ${PY3VER} ${PY2VER} "${JUPYTER_ENV}" "${TOOLS_ENV}" system

echo "\n===== Updating virtualenvwrapper.\n\n"
pip install --upgrade virtualenvwrapper
