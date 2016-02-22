#! /bin/bash

set -e  # stop on error


cd "$(dirname "$0")"

find . -mindepth 1 -type d -not -path "*.git*" \
    | cut -c 3- \
    | tr '\n' '\0' \
    | xargs -0 -n 1 mkdir -p

rsync -avh --no-perms \
    --exclude ".git/" \
    --exclude ".DS_Store" \
    --exclude "install.sh" \
    . ~;
