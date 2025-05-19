#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.

YES_INIT=0
YES_SYNC=0
OSNAME=$(uname -s | tr "[:upper:]" "[:lower:]")


function _sanity_check() {
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
}


function _main() {
    _sanity_check

    if (( $YES_INIT )); then
        ./_init.sh --yes
    else
        ./_init.sh
    fi

    # Ensure path is updated for access to homebrew binaries.
    HOMEBREW_PREFIX="/opt/homebrew"
    if [[ -x $HOMEBREW_PREFIX/bin/brew ]]; then
        eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
    fi

    if (( $YES_SYNC )); then
        ./_sync.sh --yes
    else
        ./_sync.sh
    fi

    ./_config.sh

    echo "Run the following to complete setup:"
    if [[ "$SHELL" = */zsh ]]; then
    echo "    source \"$HOME/.zshrc\""
    elif [[ "$SHELL" = */bash ]]; then
    echo "    source \"$HOME/.bashrc\""
    fi
}


function _help() {
    echo "
    Setup: install packages and dotfiles.

    Options:
      -h, --help:     Show this help
      -y, --yes:      Skip verfication before installing (both packages and dotfiles).
      --yes-init:     Skip verfication before initializing packages.
      --yes-sync:     Skip verfication before copying dotfiles.
    " | sed 's/^ \{4\}//'
}


# Process flags.
while (( $# > 0 )); do
    if [[ "$1" == "-y" || "$1" == "--yes" ]]; then
        YES_INIT=1
        YES_SYNC=1
    elif [[ "$1" == "--yes-init" ]]; then
        YES_INIT=1
    elif [[ "$1" == "--yes-sync" ]]; then
        YES_SYNC=1
    elif [[ "$1" == "-h" || "$1" == "--help" ]]; then
        _help
        exit
    else
        echo >&2 "ERROR: Unknown option $1"
        exit 1
    fi
    shift
done

_main
