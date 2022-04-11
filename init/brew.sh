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


echo "Installing homebrew packages..."
packages="
  bazel
  buildifier
  clang-format
  ctags
  gh
  git
  goenv
  hg
  hub
  icdiff
  jq
  node
  pyenv
  rbenv
  rename
  svn
  yarn
  zsh-completions
  zsh-history-substring-search
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


echo "Installing cask packages..."
packages="
  caffeine
  charles
  firefox
  font-source-code-pro
  google-chrome
  google-cloud-sdk
  google-drive
  google-trends
  iterm2
  mimestream
  rectangle
  rocket
  slack
  temurin
  visual-studio-code
"
for pkg in $packages; do
  if "$BREW" cask list $pkg &> /dev/null; then
    echo ✓  $pkg
  else
    echo 📦  $pkg
    "$BREW" install --cask --force $pkg
  fi
done
echo "Cask packages installed."
