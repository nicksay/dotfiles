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

./_init.sh
./_sync.sh --yes

echo "Run the following to complete setup:"
if [[ "$SHELL" = */zsh ]]; then
  echo "    source \"$HOME/.zshrc\""
elif [[ "$SHELL" = */bash ]]; then
  echo "    source \"$HOME/.bashrc\""
fi
