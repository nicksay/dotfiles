#!/bin/bash

set -e  # Stop on error.

# Run from the the script directory.
cd "$(dirname "$0")"

DRYRUN=0
YES=0
OSNAME=$(uname -s | tr "[:upper:]" "[:lower:]")


function _rsync() {
    if (( $DRYRUN )); then
        echo rsync $@
        rsync -n $@
    else
        rsync $@
    fi
}


function _copy_dotfiles() {
    # Copy files into place.
    _rsync -avh --no-perms --chmod=ugo=rwX --mkpath \
        --exclude ".DS_Store" \
        "$PWD/shared/" "$HOME/";
    if [[ -d "$OSNAME" ]]; then
        _rsync -avh --no-perms --chmod=ugo=rwX --mkpath \
            --exclude ".DS_Store" \
            "$PWD/$OSNAME/" "$HOME/";
    fi
}


function _main() {
    echo
    echo "Copying dotfiles..."
    if (( $DRYRUN )); then
        echo "Dry run: commands will only be printed."
        echo
    elif ! (( $YES )); then
        echo "Installing may overwrite files; use --dry-run to see which ones."
        read -p "Do you want to continue? (y/N) " -n 1;
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit
        fi
        echo
    fi
    _copy_dotfiles
    echo "Dotfiles copied."
}


function _help() {
    echo "
    Copy dotfiles to home directory

    Options:
      -h, --help:     Show this help
      -n, --dry-run:  Show what would have been done, but don't do it.
      -y, --yes:      Skip verfication before installing.
    " | sed 's/^ \{4\}//'
}


# Process flags.
while (( $# > 0 )); do
    if [[ "$1" == "-n" || "$1" == "--dry-run" ]]; then
        DRYRUN=1
    elif [[ "$1" == "-y" || "$1" == "--yes" ]]; then
        YES=1
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
