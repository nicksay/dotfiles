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
  homebrew/cask
  homebrew/cask-fonts
"
for repo in $repositories; do
  if "$BREW" tap | fgrep -q -x $repo; then
    echo ✓  $repo
  else
    echo 📦  $repo
    "$BREW" tap $repo
  fi
done


echo "Installing cask packages..."
packages="
  adoptopenjdk8
  caffeine
  charles
  dropbox
  firefox
  font-source-code-pro
  google-chrome
  google-cloud-sdk
  google-backup-and-sync
  google-trends
  iterm2
  rectangle
  simplenote
  slack
  visual-studio-code
"
for pkg in $packages; do
  if "$BREW" cask list $pkg &> /dev/null; then
    echo ✓  $pkg
  else
    echo 📦  $pkg
    "$BREW" cask install --force $pkg
  fi
done
echo "Cask packages installed."


echo "Installing homebrew packages..."
packages="
  bazel
  buildifier
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
  yarn
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
