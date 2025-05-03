#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.

# Sanity check.
if [[ "$(uname -s)" == "Darwin" ]]; then
    if xcode-select -p &> /dev/null; then
        true
    else
        echo >&2 "ERROR: developer tools need to be installed."
        echo >&2 "Run \"xcode-select --install\" and try again."
        exit 1
    fi
fi

./init/defaults.sh
./init/shell.sh
./init/brew.sh
./init/term.sh
./init/code.sh
./init/go.sh
./init/node.sh
./init/python.sh
./init/ruby.sh

./install.sh

echo "Run the following to complete setup:"
if [[ "$SHELL" = */zsh ]]; then
  echo source "\"$HOME/.zshrc\""
elif [[ "$SHELL" = */bash ]]; then
  echo source "\"$HOME/.bashrc\""
fi
