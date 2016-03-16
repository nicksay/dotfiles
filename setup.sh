#! /bin/bash

set -e  # stop on error


LOCAL="$HOME/local"


# Change to the script directory.
cd "$(dirname "$0")"

# Install developer tools if needed.
if [[ $(xcode-select --install 2>&1) != *"already installed"* ]]; then
  echo "Error: developer tools need to be installed."
  exit 1
else
  echo "Developer tools are already installed."
fi

# Install local files.
./install.sh

# Install homebrew if needed.
if [[ ! -e "$LOCAL/bin/brew" ]]; then
  echo "Installing homebrew..."
  homebrew_url="https://github.com/Homebrew/homebrew/archive/master.zip"
  curl -sL "$homebrew_url" -o homebrew.zip
  unzip -q homebrew.zip
  mkdir -p "$LOCAL"
  find homebrew-master -mindepth 1 -maxdepth 1 \
      | cut -d / -f 2- \
      | tr '\n' '\0' \
      | xargs -0 -n 1 -I __file__ mv homebrew-master/__file__ $LOCAL/
  rm -rf homebrew-master
  rm homebrew.zip
  echo "Homebrew installed."
else
  echo "Homebrew is already installed."
fi

# Install homebrew packages.
echo "Installing homebrew pacakges..."
BREW="$LOCAL/bin/brew"
"$BREW" install git
"$BREW" install hub
"$BREW" install icdiff
"$BREW" install node
echo "Homebrew pacakges installed."
