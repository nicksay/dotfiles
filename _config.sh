#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.

OSNAME=$(uname -s | tr "[:upper:]" "[:lower:]")

YES=0
unset EMAIL  # use unset for default to check for null vs empty string
unset NAME   # use unset for default to check for null vs empty string


function _main() {
    if ${EMAIL+false}; then
        unset default_email
    else
        default_email="$EMAIL"
    fi
    if ${NAME+false}; then
        if which finger &> /dev/null; then
            default_name=$(finger -l | fgrep Name: | cut -f3 -d: | xargs)
        elif which getent &> /dev/null; then
            default_name=$(getent passwd $USER | cut -f5 -d: | cut -f1 -d,)
        else
            unset default_name
        fi
    else
        default_name="$NAME"
    fi
    if (( $YES )); then
        email="$default_email"
        name="$default_name"
    else
        echo
        echo "Enter your email to customize config files (e.g. ~/.gitconfig)."
        read -p "email (default = \"$default_email\"): "
        email="${REPLY-$default_email}"
        email=$(echo "$email" | tr -d '[:space:]')  # strip all whitespace
        if [[ -z "$email" ]]; then
            email="$default_email"
        fi
        echo "Enter your name to customize config files (e.g. ~/.gitconfig)."
        read -p "name (default = \"$default_name\"): "
        name="${REPLY-$default_name}"
        name=$(echo "$name" | xargs) # trim leading/trailing whitespace
        if [[ -z "$name" ]]; then
            name="$default_name"
        fi
    fi
    echo
    echo "Customizing config files for \"$name\" <$email> ..."
    echo

    if [[ -n "$email" ]] || ! ${default_email+false}; then
        echo "> git config --global user.email \"$email\""
        git config --global user.email "$email"
    else
        echo "No email entered; skipping."
    fi
    if [[ -n "$name" ]] || ! ${default_name+false}; then
        echo "> git config --global user.name \"$name\""
        git config --global user.name "$name"

    else
        echo "No name entered; skipping."
    fi
}

function _help() {
    echo "
    Config: Customize configs in dotfiles.

    Options:
      -h, --help:       Show this help
      -y, --yes:        Skip verfication before configuring.
      --email <email>:  Use an email as the default value.
      --name <name>:    Use a name as the default value.
    " | sed 's/^ \{4\}//'
}


# Process flags.
while (( $# > 0 )); do
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        _help
        exit
    elif [[ "$1" == "-y" || "$1" == "--yes" ]]; then
        YES=1
    elif [[ "$1" == "--email" ]]; then
        if ${2+false} || [[ "$2" == "--"* ]]; then
            echo >&2 "ERROR: must specify a value for --email"
            exit 1
        fi
        EMAIL="$2"
        shift
    elif [[ "$1" == "--name" ]]; then
        if ${2+false} || [[ "$2" == "--"* ]]; then
            echo >&2 "ERROR: must specify a value for --name"
            exit 1
        fi
        NAME="$2"
        shift
    else
        echo >&2 "ERROR: Unknown option $1"
        exit 1
    fi
    shift
done

_main
