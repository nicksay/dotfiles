#! /bin/bash

set -e  # stop on error

# Global variables.
DRYRUN=0


# Functions to handle dry-run versions of commands.
function _mkdir {
  # To handle paths piped from find which may have spaces, add the "mkdir"
  # to each line, echo to the console via tee, then remove the "mkdir" to
  # be able to pass the paths to mkdir via xargs.
  sed "s/^/mkdir $@ /" \
      | tee /dev/tty \
      | (
          (( $DRYRUN )) || (
            sed "s/^mkdir $@ //" \
                | tr '\n' '\0' \
                | xargs -0 mkdir $@
          )
        )
}

function _rsync {
  if (( $DRYRUN )); then
    echo rsync $@
    rsync -n $@
  else
    rsync $@
  fi
}


# Process flags.
while (( $# > 0 )); do
  if [[ "$1" == "-n" || "$1" == "--dry-run" ]]; then
    DRYRUN=1
    echo "
      Dry run! Commands will not be run, just printed.
    " | sed 's/^ \{6\}//'
  elif [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "
      Install dotfiles

      Options:
        -h, --help:     Show this help
        -n, --dry-run:  Show what would have been done, but don't do it.
    " | sed 's/^ \{6\}//'
  else
    echo >&2 "ERROR: Unknown option $1"
    exit 1
  fi
  shift
done


# Change to the script directory.
cd "$(dirname "$0")"

# Make needed directories.
find "$PWD" -mindepth 1 -type d -not -path '*.git*' \
    | sed -e "s/^${PWD//\//\\/}/${HOME//\//\\/}/" \
    | _mkdir -p

# Copy files into place.
_rsync -avh --no-perms \
    --exclude ".git/" \
    --exclude ".DS_Store" \
    --exclude "init" \
    --exclude "install.sh" \
    --exclude "setup.sh" \
    "$PWD/" "$HOME/";
