#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.

./init/defaults.sh
./init/shell.sh
./init/brew.sh
./init/apt.sh
./init/code.sh
./init/go.sh
./init/node.sh
./init/python.sh
./init/ruby.sh
./init/rust.sh
