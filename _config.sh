#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.

echo
echo "Enter your email to customize config files (e.g. ~/.gitconfig)."
read -p "email: "
email=${REPLY//[[:space:]}  # strip all whitespace
if [[ -z "$email" ]]; then
    echo "No email entered; skipping customization."
else
    if which finger &> /dev/null; then
        name=$(finger -l | fgrep Name: | cut -f3 -d: | xargs)
    elif which getent &> /dev/null; then
        name=$(getent passwd $USER | cut -f5 -d: | cut -f1 -d,)
    fi
    echo "Enter your name to customize config files (e.g. ~/.gitconfig)."
    read -p "name (default = \"$name\"): "
    name="${REPLY:-$name}"
    name=$(echo $name | xargs) # trim leading/trailing whitespace
    echo "Customizing config files for $email ($name)..."
    echo
    echo "Customizing git..."
    echo "> git config --global user.email $email"
    git config --global user.email $email
    echo "> git config --global user.name \"$name\""
    git config --global user.name "$name"
fi
