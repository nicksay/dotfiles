#! /bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


# Sanity check.
if xcode-select -p &> /dev/null; then
  true
else
  echo >&2 "ERROR: developer tools need to be installed."
  echo >&2 "Run \"xcode-select --install\" and try again."
  exit 1
fi

./install.sh

./init/defaults.sh
./init/brew.sh
./init/go.sh
./init/node.sh
./init/python.sh
./init/ruby.sh
./init/term.sh
./init/code.sh

if [[ "$SHELL" = */zsh ]]; then
  source "$HOME/.zshrc"
elif [[ "$SHELL" = */bash ]]; then
  source "$HOME/.bashrc"
fi
