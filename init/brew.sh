#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


LOCAL="$HOME/local"
BREW="$LOCAL/bin/brew"


if [[ -e "$BREW" ]]; then
  echo "Homebrew already installed."
else
  echo "Installing homebrew..."
  homebrew_url="https://github.com/Homebrew/homebrew/archive/master.zip"
  curl -sL "$homebrew_url" -o homebrew.zip
  unzip -q homebrew.zip
  mkdir -p "$LOCAL"
  find homebrew-master -mindepth 1 -maxdepth 1 \
      | cut -d / -f 2- \
      | tr '\n' '\0' \
      | xargs -0 -n 1 -I __file__ mv homebrew-master/__file__ "$LOCAL/"
  rm -rf homebrew-master
  rm homebrew.zip
  echo "Homebrew installed."
fi


echo "Installing homebrew packages..."
packages="
  git
  hub
  icdiff
  jq
  node
  pyenv
  rbenv
"
for pkg in $packages; do
  if "$BREW" list $pkg &> /dev/null; then
    echo $pkg ✓
  else
    echo $pkg
    "$BREW" install $pkg
  fi
done
echo "Homebrew packages installed."
