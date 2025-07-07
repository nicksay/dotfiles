#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.

OSNAME=$(uname -s | tr "[:upper:]" "[:lower:]")


CARGO="$HOME/.cargo/bin/cargo"

if [[ -e "$CARGO" ]]; then
    echo "Rust already installed."
else
    echo "Installing Rust..."
    if [[ "$OSNAME" == "darwin" ]]; then
        HOMEBREW_PREFIX="/opt/homebrew"
        RUSTUP_INIT="$HOMEBREW_PREFIX/bin/rustup-init"
        if [[ ! -e "$RUSTUP_INIT" ]]; then
            echo
            echo "WARNING: rustup not found."
            exit
        fi
    else
        RUSTUP_INIT="/tmp/rustup-init.sh"
        if [[ ! -x "$RUSTUP_INIT" ]]; then
            curl -fsSL https://sh.rustup.rs -o "$RUSTUP_INIT"
            chmod +x "$RUSTUP_INIT"
        fi
    fi
    $RUSTUP_INIT -y --no-modify-path
    echo "Rust installed."
fi


echo "Installing Rust commands..."
packages="
    cargo-machete
    checkexec
    watchexec-cli
"
CARGO="$HOME/.cargo/bin/cargo"
installed=$("$CARGO" install --list | fgrep : | awk '{print $1}')
for pkg in $packages; do
  if echo "$installed" | fgrep -q -x ${pkg%@*}; then
   echo ✓  $pkg
  else
    echo 📦  $pkg
    "$CARGO" install $pkg
  fi
done
echo "Rust commands installed."
