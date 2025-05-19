#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.

OSNAME=$(uname -s | tr "[:upper:]" "[:lower:]")


if [[ "$OSNAME" == "darwin" ]]; then
  HOMEBREW_PREFIX="/opt/homebrew"
  PYENV="$HOMEBREW_PREFIX/bin/pyenv"
  if [[ ! -e "$PYENV" ]]; then
    echo
    echo "WARNING: pyenv not found."
    exit
  fi
else
  PYENV="$HOME/.pyenv/bin/pyenv"
  if [[ ! -e "$PYENV" ]]; then
    echo "Installing pyenv..."
    /bin/bash -c "$(curl -fsSL https://pyenv.run)"
    echo "pyenv installed."
  fi
fi
PIP="$HOME/.pyenv/shims/pip"


if "$PYENV" version | cut -d ' ' -f 1 | egrep -q '[0-9]+\.[0-9]+\.[0-9]+'; then
  echo "Python already installed."
else
  echo "Installing python..."
  python_version=$("$PYENV" install -l | egrep '\s+[0-9]+\.[0-9]+\.[0-9]+$' | tail -1)
  "$PYENV" install $python_version
  "$PYENV" global $python_version
  echo "Python installed."
fi


echo "Installing python packages..."
packages="
  numpy
  pylint
  yapf
"
for pkg in $packages; do
  if "$PIP" show $pkg &> /dev/null; then
    echo ✓  $pkg
  else
    echo 📦  $pkg
    "$PIP" install $pkg
  fi
done
echo "Python packages installed."
