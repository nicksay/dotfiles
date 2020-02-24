#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


BCT_SHELL="$HOME/.bash_command_timer.sh"
ITERM2_PREFS="$HOME/Library/Application Support/iTerm2/Preferences/com.googlecode.iterm2.plist"
ITERM2_SHELL_DIR="$HOME/.iterm2/"
ITERM2_SHELL_BASH="$HOME/.iterm2/shell_integration.bash"
ITERM2_SHELL_ZSH="$HOME/.iterm2/shell_integration.zsh"
OH_MY_ZSH="$HOME/.oh-my-zsh/oh-my-zsh.sh"
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
echo "Installing shell customization..."
if [[ -e "$BCT_SHELL" ]]; then
  echo ✓  bash-command-timer
else
  echo 📦  bash-command-timer
  url="https://raw.githubusercontent.com/jichu4n/bash-command-timer/master/bash_command_timer.sh"
  curl -sL "$url" -o "$BCT_SHELL"
fi
if [[ -e "$OH_MY_ZSH" ]]; then
  echo ✓  oh-my-zsh
else
  echo 📦  oh-my-zsh
  url="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
  sh -c "$(curl -sL $url)"
fi
echo "Shell customization installed."

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
