#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.

OSNAME=$(uname -s | tr "[:upper:]" "[:lower:]")


if [[ "$OSNAME" != "darwin" ]]; then
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
"
tapped=$("$BREW" tap)
for repo in $repositories; do
  if echo "$tapped" | fgrep -q -x $repo; then
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
  firebase-cli
  gh
  git
  git-filter-repo
  glab
  goenv
  graphviz
  helm
  hub
  icdiff
  jq
  just
  kubectx
  kubernetes-cli
  lima
  libyaml
  marked
  mercurial
  micro
  miniserve
  openjdk
  optipng
  podman
  pnpm
  pyenv
  pyenv-virtualenv
  qemu
  rbenv
  rename
  rsync
  ruby-build
  rustup
  sqlite
  sqlite-utils
  subversion
  tree
  yarn
  yq
  zsh-completions
  zsh-history-substring-search
"
installed=$("$BREW" list -1 --formula)
for pkg in $packages; do
  # Can't use -x to match full string because some packages might be listed
  # with version numbers (e.g. python@3.12).
  if echo "$installed" | egrep -q "^$pkg\b"; then
    echo ✓  $pkg
  else
    echo 📦  $pkg
    "$BREW" install $pkg
    # Some packages have extra post-install steps.
    case $pkg in
        openjdk)
            echo "Symlinking openjdk for system Java wrappers to find..."
            echo "> sudo ln -sfn " \
                    "$HOMEBREW_PREFIX/opt/openjdk/libexec/openjdk.jdk" \
                    "/Library/Java/JavaVirtualMachines/openjdk.jdk"
            sudo ln -sfn \
                    "$HOMEBREW_PREFIX"/opt/openjdk/libexec/openjdk.jdk \
                    /Library/Java/JavaVirtualMachines/openjdk.jdk
            ;;
    esac
  fi
done
echo "Homebrew packages installed."


echo "Installing cask packages..."
packages="
  firefox
  font-blex-mono-nerd-font
  font-inter
  font-inter-tight
  font-meslo-lg-nerd-font
  font-noto-mono
  font-noto-sans
  font-noto-sans-mono
  font-noto-serif
  font-source-code-pro
  font-source-sans-3
  font-source-serif-4
  font-zed-mono
  font-zed-mono-nerd-font
  font-zed-sans
  gcloud-cli
  ghostty
  google-chrome
  google-drive
  mimestream
  notion-calendar
  obsidian
  podman-desktop
  slack
  signal
  topnotch
  visual-studio-code
  zed
"
installed=$("$BREW" list -1 --cask)
for pkg in $packages; do
  if echo "$installed" | fgrep -q -x $pkg; then
    echo ✓  $pkg
  else
    echo 📦  $pkg
    "$BREW" install --adopt --cask $pkg
  fi
done
echo "Cask packages installed."
