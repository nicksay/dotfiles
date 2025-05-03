#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Skipping homebrew installation."
    exit 0
fi


HOMEBREW_PREFIX="/opt/homebrew"
BREW="$HOMEBREW_PREFIX/bin/brew"


echo
if [[ -e "$BREW" ]]; then
  echo "Homebrew already installed."
else
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
  awscli
  bazelisk
  buildifier
  clang-format
  ctags
  gh
  ghostty
  git
  git-filter-repo
  glab
  goenv
  helm
  hg
  hub
  icdiff
  kubectl
  kubectx
  jq
  libyaml
  marked
  openjdk
  pnpm
  pyenv
  pyenv-virtualenv
  rbenv
  rename
  ruby-build
  rustup-init
  sqlite
  sqlite-utils
  svn
  yarn
  zed
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
  firefox
  font-inter
  font-inter-tight
  font-noto-mono
  font-noto-sans
  font-noto-sans-mono
  font-noto-serif
  font-source-code-pro
  font-zed-mono
  font-zed-sans
  google-chrome
  google-cloud-sdk
  google-drive
  iterm2
  mimestream
  notion-calendar
  slack
  signal
  topnotch
  visual-studio-code
  zed
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
