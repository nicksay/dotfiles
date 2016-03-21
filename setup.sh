#! /bin/bash

set -e  # stop on error


LOCAL="$HOME/local"
FONTS="$HOME/Library/Fonts"


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

# Do initialization from local files.
SUBLIME_TEXT="Library/Application Support/Sublime Text 3"
if [[ ! -e "$HOME/$SUBLIME_TEXT/Installed Packages/Package Control.sublime-package" ]]; then
  echo "Installing package control..."
  mkdir -p "$HOME/$SUBLIME_TEXT/Installed Packages/"
  package_control_url="https://packagecontrol.io/Package%20Control.sublime-package"
  curl -sL "$package_control_url" -o "$HOME/$SUBLIME_TEXT/Installed Packages/Package Control.sublime-package"
  echo "Package control installed."
else
  echo "Package control already installed."
fi
if [[ ! -e "$HOME/$SUBLIME_TEXT/Packages/User/Package Control.sublime-settings" ]]; then
  echo "Installing package control settings..."
  mkdir -p "$HOME/$SUBLIME_TEXT/Packages/User/"
  cp "init/Package Control.sublime-settings" "$HOME/$SUBLIME_TEXT/Packages/User/"
  echo "Package control settings installed."
else
  echo "Package control settings already installed."
fi
echo "Installing terminal theme..."
open "init/Base16 Space Gray.terminal"
osascript <<END_OF_SCRIPT
  tell application "Terminal"
    delay 1
    set default settings to settings set "Base16 Space Gray"
    set all_window_ids to id of every window
    repeat with window_id in all_window_ids
      set current settings of tabs of (every window whose id is window_id) to settings set "Base16 Space Gray"
    end repeat
  end tell
END_OF_SCRIPT
echo "Terminal theme installed."

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
      | xargs -0 -n 1 -I __file__ mv homebrew-master/__file__ "$LOCAL/"
  rm -rf homebrew-master
  rm homebrew.zip
  echo "Homebrew installed."
else
  echo "Homebrew is already installed."
fi

# Install homebrew packages.
echo "Installing homebrew packages..."
BREW="$LOCAL/bin/brew"
"$BREW" list git &> /dev/null || "$BREW" install git
"$BREW" list hub &> /dev/null || "$BREW" install hub
"$BREW" list icdiff &> /dev/null || "$BREW" install icdiff
"$BREW" list node &> /dev/null || "$BREW" install node
"$BREW" list pyenv &> /dev/null || "$BREW" install pyenv
"$BREW" list rbenv &> /dev/null || "$BREW" install rbenv
echo "Homebrew packages installed."

# Install python and packages.
PYENV="$LOCAL/bin/pyenv"
if [[ -e "$PYENV" ]]; then
  if ! "$PYENV" version | cut -d ' ' -f 1 | egrep -q '\d+\.\d+\.\d+'; then
    echo "Installing python..."
    python_version=$("$PYENV" install -l | egrep '\s+\d+\.\d+\.\d+$' | tail -1)
    "$PYENV" install $python_version
    "$PYENV" global $python_version
    echo "Python installed."
  else
    echo "Python already installed."
  fi
  echo "Installing python packages..."
  PIP="$HOME/.pyenv/shims/pip"
  "$PIP" list yapf | egrep -q '^yapf ' || "$PIP" install yapf
  echo "Python packages installed."
else
  echo "WARNING: pyenv not found."
fi

# Install ruby and packages.
RBENV="$LOCAL/bin/rbenv"
if [[ -e "$RBENV" ]]; then
  if ! "$RBENV" version | cut -d ' ' -f 1 | egrep -q '\d+\.\d+\.\d+'; then
    echo "Installing ruby..."
    ruby_version=$("$RBENV" install -l | egrep '\s+\d+\.\d+\.\d+$' | tail -1)
    "$RBENV" install $ruby_version
    "$RBENV" global $ruby_version
    echo "Ruby installed."
  else
    echo "Ruby already installed."
  fi
  echo "Installing ruby packages..."
  GEM="$HOME/.rbenv/shims/gem"
  "$GEM" list --installed bundler &> /dev/null || "$GEM" install bundler
  echo "Ruby packages installed."
else
  echo "WARNING: rbenv not found."
fi

# Install fonts.
if [[ ! -e "$FONTS/SourceCodePro-Medium.otf" ]]; then
  echo "Installing fonts..."
  source_code_pro_url=$(curl -s "https://api.github.com/repos/adobe-fonts/source-code-pro/releases/latest" \
                                              | fgrep zipball_url \
                                              | tr -d ' ,"' \
                                              | cut -d : -f 2-)
  curl -sL "$source_code_pro_url" -o source_code_pro.zip
  unzip -q source_code_pro.zip
  mkdir -p "$FONTS"
  find adobe-fonts-source-code-pro* -iname "*.otf" \
      | tr '\n' '\0' \
      | xargs -0 -n 1 -I __file__ mv __file__ "$FONTS/"
  rm -rf adobe-fonts-source-code-pro*
  rm source_code_pro.zip
  echo "Fonts installed."
else
  echo "Fonts are already installed."
fi
