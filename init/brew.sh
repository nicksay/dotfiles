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


echo "Tapping homebrew repositories..."
repositories="
  googlechrome/simplehttp2server
"
for repo in $repositories; do
  if "$BREW" tap | fgrep -q -x $repo; then
    echo ✓  $repo
  else
    echo 📦  $repo
    "$BREW" tap $repo https://github.com/$repo
  fi
done


echo "Installing homebrew packages..."
packages="
  clang-format
  ctags
  git
  hg
  hub
  icdiff
  jq
  node
  pyenv
  rbenv
  rename
  simplehttp2server
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
