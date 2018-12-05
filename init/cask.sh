#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


LOCAL="$HOME/local"
BREW="$LOCAL/bin/brew"


echo
if "$BREW" tap | fgrep -q -x homebrew/cask; then
  echo "Cask already installed."
else
  echo "Installing cask..."
  "$BREW" tap homebrew/cask
  echo "Cask installed."
fi


echo "Tapping cask repositories..."
repositories="
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
  caffeine
  charles
  dropbox
  firefox
  font-source-code-pro
  google-chrome
  google-backup-and-sync
  iterm2
  java
  simplenote
  slack
  sublime-text
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
