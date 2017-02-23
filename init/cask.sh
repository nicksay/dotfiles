#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


LOCAL="$HOME/local"
BREW="$LOCAL/bin/brew"
CASK="$BREW cask"


echo
if "$BREW" tap | fgrep -q -x caskroom/cask; then
  echo "Cask already installed."
else
  echo "Installing cask..."
  "$BREW" tap caskroom/cask
  echo "Cask installed."
fi


echo "Installing cask packages..."
packages="
  caffeine
  dropbox
  google-chrome
  google-drive
  iterm2
  sublime-text
"
for pkg in $packages; do
  if "$CASK" list $pkg &> /dev/null; then
    echo ✓  $pkg
  else
    echo 📦  $pkg
    "$CASK" install $pkg
  fi
done
echo "Cask packages installed."
