#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


LOCAL="$HOME/local"
GOENV="$LOCAL/bin/goenv"
GO="$HOME/.goenv/shims/go"


echo
if [[ ! -e "$GOENV" ]]; then
  echo "WARNING: goenv not found."
  exit
fi

if "$GOENV" version | cut -d ' ' -f 1 | egrep -q '\d+\.\d+\.\d+'; then
  echo "Go already installed."
else
  echo "Installing go..."
  go_version=$("$GOENV" install -l | egrep '\s+\d+\.\d+\.\d+$' | tail -1)
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
eval "$("$GOENV" init -)"
for pkg in $packages; do
  if "$GO" list $pkg &> /dev/null; then
   echo ✓  $pkg
  else
    echo 📦  $pkg
    "$GO" install $pkg
  fi
done
echo "Go commands installed."
