#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


LOCAL="$HOME/local"
NPM="$LOCAL/bin/npm"


echo
if [[ ! -e "$NPM" ]]; then
  echo "WARNING: npm not found."
  exit
fi


echo "Installing node packages..."
packages="
  eslint
  tslint
  typescript
"
for pkg in $packages; do
  if "$NPM" ls -g --parseable $pkg > /dev/null; then
    echo ✓  $pkg
  else
    echo 📦  $pkg
    "$NPM" install $pkg
  fi
done
echo "Node packages installed."
