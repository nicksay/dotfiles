#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.

OSNAME=$(uname -s | tr "[:upper:]" "[:lower:]")

YES_INIT=0
YES_SYNC=0
YES_CONFIG=0
unset CONFIG_EMAIL  # use unset for default to check for null vs empty string
unset CONFIG_NAME   # use unset for default to check for null vs empty string


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

    config_flags=( )
    if (( $YES_CONFIG )); then
        config_flags+=( "--yes" )
    fi
    if ! ${CONFIG_EMAIL+false}; then
        config_flags+=( "--email" "$CONFIG_EMAIL" )
    fi
    if ! ${CONFIG_NAME+false}; then
        config_flags+=( "--name" "$CONFIG_NAME" )
    fi
    ./_config.sh "${config_flags[@]}"

    echo
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
      -h, --help:              Show this help
      -y, --yes:               Skip verfication before installing (for all).
      --yes-init:              Skip verfication before initializing packages.
      --yes-sync:              Skip verfication before copying dotfiles.
      --yes-config:            Skip verfication before configuring.
      --config-email <email>:  Pass an email for use during configuration.
      --config-name <name>:    Pass a name for use during configuration.
    " | sed 's/^ \{4\}//'
}


# Process flags.
while (( $# > 0 )); do
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        _help
        exit
    elif [[ "$1" == "-y" || "$1" == "--yes" ]]; then
        YES_INIT=1
        YES_SYNC=1
        YES_CONFIG=1
    elif [[ "$1" == "--yes-init" ]]; then
        YES_INIT=1
    elif [[ "$1" == "--yes-sync" ]]; then
        YES_SYNC=1
    elif [[ "$1" == "--yes-config" ]]; then
        YES_CONFIG=1
    elif [[ "$1" == "--config-email" ]]; then
        if ${2+false} || [[ "$2" == "--"* ]]; then
            echo >&2 "ERROR: must specify a value for --config-email"
            exit 1
        fi
        CONFIG_EMAIL="$2"
        shift
    elif [[ "$1" == "--config-name" ]]; then
        if ${2+false} || [[ "$2" == "--"* ]]; then
            echo >&2 "ERROR: must specify a value for --config-name"
            exit 1
        fi
        CONFIG_NAME="$2"
        shift
    else
        echo >&2 "ERROR: Unknown option $1"
        exit 1
    fi
    shift
done

_main
