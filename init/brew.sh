#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


LOCAL="$HOME/local"
BREW="$LOCAL/bin/brew"


echo
if [[ -e "$BREW" ]]; then
  echo "Homebrew already installed."
else
  echo "Installing homebrew..."
  mkdir -p "$LOCAL"
  homebrew_url="https://github.com/Homebrew/brew/tarball/master"
  curl -sL "$homebrew_url" | tar xz --strip 1 -C "$LOCAL"
  echo "Homebrew installed."
fi


echo "Installing homebrew packages..."
packages="
  git
  hg
  hub
  icdiff
  jq
  node
  pyenv
  rbenv
  rename
"
for pkg in $packages; do
  if "$BREW" list $pkg &> /dev/null; then
    echo ✓  $pkg
  else
    echo 📦  $pkg
    "$BREW" install $pkg
  fi
done
echo "Homebrew packages installed."
