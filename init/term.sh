#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


BCT_SHELL="$HOME/.bash_command_timer.sh"
ITERM2_PREFS="$HOME/Library/Application Support/iTerm2/Preferences/com.googlecode.iterm2.plist"
ITERM2_SHELL="$HOME/.iterm2_shell_integration.bash"
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
if [[ -e "$ITERM2_SHELL" ]]; then
  echo ✓  iTerm2
else
  echo 📦  iTerm2
  url="https://iterm2.com/misc/install_shell_integration_and_utilities.sh"
  curl -sL "$url" | bash
fi
if [[ -e "$BCT_SHELL" ]]; then
  echo ✓  bash-command-timer
else
  echo 📦  bash-command-timer
  url="https://raw.githubusercontent.com/jichu4n/bash-command-timer/master/bash_command_timer.sh"
  curl -sL "$url" -o "$BCT_SHELL"
fi
echo "Shell integration installed."
