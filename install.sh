#! /bin/bash

set -e  # stop on error


cd "$(dirname "$0")"

rsync -avh --no-perms \
    --exclude ".git/" \
    --exclude ".DS_Store"
    --exclude "install.sh" \
    . ~;
