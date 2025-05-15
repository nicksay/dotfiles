#!/bin/bash

set -e  # Stop on error.

# Run from the the script directory.
cd "$(dirname "$0")"


DRYRUN=0
YES=0
OSNAME="$(uname -s)"


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
  find "$PWD/shared" -mindepth 1 -type d -not -path '*.git*' \
      | sed -e "s/^${PWD//\//\\/}/${HOME//\//\\/}/" \
      | _mkdir -p
  case "$OSNAME" in
    "Darwin")
      find "$PWD/macos" -mindepth 1 -type d -not -path '*.git*' \
          | sed -e "s/^${PWD//\//\\/}/${HOME//\//\\/}/" \
          | _mkdir -p
      ;;
  esac
  # Copy files into place.
  _rsync -avh --no-perms --chmod=ugo=rwX \
      --exclude ".DS_Store" \
      "$PWD/shared/" "$HOME/";
  case "$OSNAME" in
    "Darwin")
      _rsync -avh --no-perms --chmod=ugo=rwX \
          --exclude ".DS_Store" \
          "$PWD/macos/" "$HOME/";
          ;;
  esac
  echo "Dotfiles copied."
}


function _main() {
  echo
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
}


function _help() {
  echo "
    Install dotfiles

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
