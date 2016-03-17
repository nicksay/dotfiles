#! /bin/bash

set -e  # stop on error


# Change to the script directory.
cd "$(dirname "$0")"

# Update the files.
git pull origin

# Make needed directories.
find . -mindepth 1 -type d -not -path "*.git*" \
    | cut -c 3- \
    | tr '\n' '\0' \
    | xargs -0 -n 1 mkdir -p

# Copy files into place.
rsync -avh --no-perms \
    --exclude ".git/" \
    --exclude ".DS_Store" \
    --exclude "init" \
    --exclude "install.sh" \
    --exclude "setup.sh" \
    . ~;
