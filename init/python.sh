#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


LOCAL="$HOME/local"
PYENV="$LOCAL/bin/pyenv"
PIP="$HOME/.pyenv/shims/pip"


echo
if [[ ! -e "$PYENV" ]]; then
  echo "WARNING: pyenv not found."
  exit
fi

if "$PYENV" version | cut -d ' ' -f 1 | egrep -q '\d+\.\d+\.\d+'; then
  echo "Python already installed."
else
  echo "Installing python..."
  python_version=$("$PYENV" install -l | egrep '\s+\d+\.\d+\.\d+$' | tail -1)
  "$PYENV" install $python_version
  "$PYENV" global $python_version
  echo "Python installed."
fi


echo "Installing python packages..."
packages="
  numpy
  yapf
"
for pkg in $packages; do
  if "$PIP" list --format columns $pkg | egrep -q "^$pkg "; then
    echo ✓  $pkg
  else
    echo 📦  $pkg
    "$PIP" install $pkg
  fi
done
echo "Python packages installed."
