#! /bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


# Sanity check.
if [[ $(xcode-select --install 2>&1) != *"already installed"* ]]; then
  echo >&2 "ERROR: developer tools need to be installed."
  exit 1
fi

./install.sh

./init/brew.sh
./init/cask.sh
./init/python.sh
./init/ruby.sh
./init/fonts.sh
./init/term.sh
./init/subl.sh
