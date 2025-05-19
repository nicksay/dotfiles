#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


OSNAME=$(uname -s | tr "[:upper:]" "[:lower:]")


# Sanity check.
if [[ "$OSNAME" == "darwin" ]]; then
    if xcode-select -p &> /dev/null; then
        true
    else
        echo >&2 "ERROR: developer tools need to be installed."
        echo >&2 "Run \"xcode-select --install\" and try again."
        exit 1
    fi
fi

./_init.sh

# Ensure path is updated for access to homebrew binaries.
HOMEBREW_PREFIX="/opt/homebrew"
if [[ -x $HOMEBREW_PREFIX/bin/brew ]]; then
    eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi

./_sync.sh --yes

./_config.sh

echo "Run the following to complete setup:"
if [[ "$SHELL" = */zsh ]]; then
  echo "    source \"$HOME/.zshrc\""
elif [[ "$SHELL" = */bash ]]; then
  echo "    source \"$HOME/.bashrc\""
fi
