#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


HOMEBREW_PREFIX="/opt/homebrew"
RBENV="$HOMEBREW_PREFIX/bin/rbenv"
GEM="$HOME/.rbenv/shims/gem"
PATH="$HOMEBREW_PREFIX/bin:$PATH"


echo
if [[ ! -e "$RBENV" ]]; then
  echo "WARNING: rbenv not found."
  exit
fi

if "$RBENV" version | cut -d ' ' -f 1 | egrep -q '\d+\.\d+\.\d+'; then
  echo "Ruby already installed."
else
  echo "Installing ruby..."
  ruby_version=$("$RBENV" install -l | egrep '^\s*\d+\.\d+\.\d+$' | tail -1)
  "$RBENV" install $ruby_version
  "$RBENV" global $ruby_version
  echo "Ruby installed."
fi


echo "Installing ruby packages..."
packages="
  bundler
"
for pkg in $packages; do
  if "$GEM" list --installed $pkg &> /dev/null; then
    echo ✓  $pkg
  else
    echo 📦  $pkg
    "$GEM" install $pkg
  fi
done
echo "Ruby packages installed."
