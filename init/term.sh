#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Skipping terminal theme."
    exit 0
fi


ITERM2_PREFS="$HOME/Library/Application Support/iTerm2/Preferences/com.googlecode.iterm2.plist"
ITERM2_SHELL_DIR="$HOME/.iterm2/"
ITERM2_SHELL_BASH="$HOME/.iterm2/shell_integration.bash"
ITERM2_SHELL_ZSH="$HOME/.iterm2/shell_integration.zsh"

TERMINAL_PREFS="$HOME/Library/Preferences/com.apple.Terminal.plist"


echo
echo "Installing terminal theme..."
if [[ -e "$ITERM2_PREFS" ]] \
      && plutil -p "$ITERM2_PREFS" | fgrep -q "Base16 Space Gray"; then
  echo ✓  iTerm2
else
  echo 📦  iTerm2
  xattr -dr com.apple.quarantine "Base16 Space Gray.itermcolors"
  open "Base16 Space Gray.itermcolors"
fi
if [[ -e "$TERMINAL_PREFS" ]] \
      && plutil -p "$TERMINAL_PREFS" | fgrep -q "Base16 Space Gray"; then
  echo ✓  Terminal
else
  echo 📦  Terminal
  xattr -dr com.apple.quarantine "Base16 Space Gray.terminal"
  open "Base16 Space Gray.terminal"
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
fi
echo "Terminal theme installed."

echo
echo "Installing shell integration..."
mkdir -p "$ITERM2_SHELL_DIR"
if [[ -e "$ITERM2_SHELL_BASH" ]]; then
  echo ✓  iTerm2 bash
else
  echo 📦  iTerm2 bash
  url="https://iterm2.com/shell_integration/bash"
  curl -sL "$url" -o "$ITERM2_SHELL_BASH"
fi
if [[ -e "$ITERM2_SHELL_ZSH" ]]; then
  echo ✓  iTerm2 zsh
else
  echo 📦  iTerm2 zsh
  url="https://iterm2.com/shell_integration/zsh"
  curl -sL "$url" -o "$ITERM2_SHELL_ZSH"
fi
echo "Shell integration installed."
