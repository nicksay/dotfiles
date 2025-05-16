#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.

BCT_SHELL="$HOME/.bash_command_timer.sh"
OH_MY_ZSH="$HOME/.oh-my-zsh/oh-my-zsh.sh"

if [[ "$(uname -s)" == "Linux" ]]; then
  if which zsh &> /dev/null; then
    echo "zsh found."
  else
    echo "Installing zsh..."
    sudo NEEDRESTART_MODE=a apt install -y zsh
    echo "zsh installed."
  fi
fi

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
  # Note: unset $ZSH to avoid triggering a saftey check during install
  RUNZSH=no sh -c "$(curl -sL $url)"
fi
echo "Shell customization installed."
