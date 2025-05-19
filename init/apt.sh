#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.

OSNAME=$(uname -s | tr "[:upper:]" "[:lower:]")


if [[ "$OSNAME" != "linux" ]]; then
    echo "Skipping apt installation."
    exit 0
fi

echo "Installing apt packages..."
packages="
  autoconf
  automake
  bison
  ca-certificates
  clang
  clang-format
  clang-tidy
  clang-tools
  cmake
  cppcheck
  curl
  flex
  g++
  gcc
  gh
  git
  gnupg
  iputils-ping
  jq
  kmod
  lcov
  libcurl4-openssl-dev
  libssh2-1
  libssl-dev
  libtool-bin
  libyaml-dev
  llvm
  netcat
  openjdk-11-jdk
  openssh-client
  openssl
  perl
  protobuf-compiler
  python-is-python3
  python3-distutils
  python3-pip
  python3.11
  rsync
  software-properties-common
  sudo
  valgrind
  wget
  zlib1g-dev
"
pkgs_to_install=""
for pkg in $packages; do
  if dpkg -s $pkg &> /dev/null; then
    echo ✓  $pkg
  else
    echo 📦  $pkg
    pkgs_to_install="$pkgs_to_install $pkg"
  fi
done
if [[ "$pkgs_to_install" != "" ]]; then
  sudo apt update
  sudo NEEDRESTART_MODE=a apt install -y $pkgs_to_install
fi
echo "apt packages installed."

echo "Installing snap packages..."
packages="
  helm
  just
"
# sudo snap refresh
for pkg in $packages; do
  if snap list $pkg &> /dev/null; then
    echo ✓  $pkg
  else
    echo 📦  $pkg
    sudo snap install --classic $pkg
  fi
done
echo "snap packages installed."
