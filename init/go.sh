#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


if [[ "$(uname -s)" == "Darwin" ]]; then
  HOMEBREW_PREFIX="/opt/homebrew"
  GOENV="$HOMEBREW_PREFIX/bin/goenv"
  if [[ ! -e "$GOENV" ]]; then
    echo
    echo "WARNING: goenv not found."
    exit
  fi
else
  GOENV="$HOME/.goenv/bin/goenv"
  if [[ ! -e "$GOENV" ]]; then
    echo "Installing goenv..."
    git clone https://github.com/go-nv/goenv.git "$HOME/.goenv"
    echo "goenv installed."
  fi
fi
GO="$HOME/.goenv/shims/go"


if "$GOENV" version | cut -d ' ' -f 1 | egrep -q '[0-9]+\.[0-9]+\.[0-9]+'; then
  echo "Go already installed."
else
  echo "Installing go..."
  go_version=$("$GOENV" install -l | egrep '\s+[0-9]+\.[0-9]+\.[0-9]+$' | tail -1)
  "$GOENV" install -f $go_version
  "$GOENV" global $go_version
  echo "Go installed."
fi


echo "Installing go commands..."
packages="
  golang.org/x/lint/golint@latest
  github.com/GoogleChrome/simplehttp2server@latest
"
export GOENV_GOPATH_PREFIX="$HOME/.go"
for pkg in $packages; do
  if "$GO" list $pkg &> /dev/null; then
   echo ✓  $pkg
  else
    echo 📦  $pkg
    "$GO" install $pkg
  fi
done
echo "Go commands installed."
