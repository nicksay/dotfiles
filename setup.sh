#! /bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


# Sanity check.
if xcode-select -p &> /dev/null; then
  true
else
  echo >&2 "ERROR: developer tools need to be installed."
  exit 1
fi

./install.sh
source "$HOME/.bashrc"

./init/defaults.sh
./init/brew.sh
./init/cask.sh
./init/go.sh
./init/node.sh
./init/python.sh
./init/ruby.sh
./init/term.sh
./init/subl.sh
./init/code.sh
