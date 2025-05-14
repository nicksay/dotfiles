#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


if [[ "$(uname -s)" == "Darwin" ]]; then
  HOMEBREW_PREFIX="/opt/homebrew"
  export PATH="$HOMEBREW_PREFIX/bin:$PATH"
  PNPM="$HOMEBREW_PREFIX/bin/pnpm"
  if [[ ! -e "$PNPM" ]]; then
    echo
    echo "WARNING: pnpm not found."
    exit
  fi
else
  PNPM="$HOME/.local/share/pnpm/pnpm"
  if [[ ! -e "$PNPM" ]]; then
    echo "Installing pnpm..."
    /bin/bash -c "$(curl -fsSL https://get.pnpm.io/install.sh)"
    echo "pnpm installed."
  fi
fi

echo "Setting up pnpm..."
PNPM_HOME="$HOME/.local/share/pnpm"
PATH="$PNPM_HOME:$PATH"
"$PNPM" setup

echo "Installing node..."
bash -i -c "\"$PNPM\" env use --global latest"

echo "Installing node packages..."
packages="
  eslint
  typescript
"
if [[ "$(uname -s)" == "Linux" ]]; then
  packages="$packages
    @bazel/bazelisk
  "
fi
for pkg in $packages; do
  if "$PNPM" ls -g --parseable $pkg | egrep "$pkg\$" > /dev/null; then
    echo ✓  $pkg
  else
    echo 📦  $pkg
    "$PNPM" install -g $pkg
  fi
done
echo "node packages installed."
