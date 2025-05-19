#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.

OSNAME=$(uname -s | tr "[:upper:]" "[:lower:]")


if [[ "$OSNAME" == "darwin" ]]; then
  HOMEBREW_PREFIX="/opt/homebrew"
  export PATH="$HOMEBREW_PREFIX/bin:$PATH"
  RBENV="$HOMEBREW_PREFIX/bin/rbenv"
  if [[ ! -e "$RBENV" ]]; then
    echo
    echo "WARNING: rbenv not found."
    exit
  fi
else
  RBENV="$HOME/.rbenv/bin/rbenv"
  if [[ ! -e "$RBENV" ]]; then
    echo "Installing rbenv..."
    /bin/bash -c "$(curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer)"
    echo "rbenv installed."
  fi
fi
GEM="$HOME/.rbenv/shims/gem"


if "$RBENV" version | cut -d ' ' -f 1 | egrep -q '[0-9]+\.[0-9]+\.[0-9]+'; then
  echo "Ruby already installed."
else
  echo "Installing ruby..."
  ruby_version=$("$RBENV" install -l | egrep '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1)
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
