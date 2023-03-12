#!/bin/bash

set -e  # Stop on error.

# Run from the the script directory.
cd "$(dirname "$0")"


DRYRUN=0
FORCE=0


function _mkdir() {
  paths="$(< /dev/stdin)";
  if (( $DRYRUN )); then
    echo mkdir $@ $paths
  else
    echo "$paths" | tr "\n" "\0" | xargs -0 mkdir $@
  fi
}


function _rsync() {
  if (( $DRYRUN )); then
    echo rsync $@
    rsync -n $@
  else
    rsync $@
  fi
}


function _copy_dotfiles() {
  echo "Copying dotfiles..."
  # Make needed directories.
  find "$PWD" -mindepth 1 -type d -not -path '*.git*' \
      | sed -e "s/^${PWD//\//\\/}/${HOME//\//\\/}/" \
      | _mkdir -p
  # Copy files into place.
  _rsync -avh --no-perms --chmod=ugo=rwX \
      --exclude ".git/" \
      --exclude ".DS_Store" \
      --exclude "init" \
      --exclude "install.sh" \
      --exclude "setup.sh" \
      "$PWD/" "$HOME/";
  echo "Dotfiles copied."
}


function _main() {
  echo
  if (( $DRYRUN )); then
    echo "Dry run: commands will only be printed."
    echo
  elif ! (( $FORCE )); then
    echo "Installing may overwrite files; use --dry-run to see which ones."
    read -p "Do you want to continue? (y/N) " -n 1;
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit
    fi
    echo
  fi

  _copy_dotfiles
}


function _help() {
  echo "
    Install dotfiles

    Options:
      -h, --help:     Show this help
      -n, --dry-run:  Show what would have been done, but don't do it.
      -f, --force:    Skip verfication before installing.
  " | sed 's/^ \{4\}//'
}


# Process flags.
while (( $# > 0 )); do
  if [[ "$1" == "-n" || "$1" == "--dry-run" ]]; then
    DRYRUN=1
  elif [[ "$1" == "-f" || "$1" == "--force" ]]; then
    FORCE=1
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
