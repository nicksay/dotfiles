#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


GOENV_ROOT="$HOME/.goenv"
if [[ "$(uname -s)" == "Darwin" ]]; then
  HOMEBREW_PREFIX="/opt/homebrew"
  GOENV="$HOMEBREW_PREFIX/bin/goenv"
  if [[ ! -e "$GOENV" ]]; then
    echo
    echo "WARNING: goenv not found."
    exit
  fi
else
  GOENV="$GOENV_ROOT/bin/goenv"
  if [[ ! -e "$GOENV" ]]; then
    echo "Installing goenv..."
    git clone https://github.com/go-nv/goenv.git "$HOME/.goenv"
    echo "goenv installed."
  fi
fi

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
GO="$GOENV_ROOT/shims/go"
GOPATH="$HOME"/.go/$("$GOENV" version-name)
installed=$("$GO" version -m "$GOPATH"/bin/* |
            egrep "^[[:space:]]path" |
            awk '{print $2}')
for pkg in $packages; do
  if echo "$installed" | fgrep -q -x ${pkg%@*}; then
   echo ✓  $pkg
  else
    echo 📦  $pkg
    "$GO" install $pkg
  fi
done
echo "Go commands installed."
