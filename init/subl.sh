#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


SUBLIME_TEXT="$HOME/Library/Application Support/Sublime Text 3"


echo
if [[ -e "$SUBLIME_TEXT/Installed Packages/Package Control.sublime-package" ]]; then
  echo "Package control already installed."
else
  echo "Installing package control..."
  mkdir -p "$SUBLIME_TEXT/Installed Packages/"
  package_control_url="https://packagecontrol.io/Package%20Control.sublime-package"
  curl -sL "$package_control_url" -o "$SUBLIME_TEXT/Installed Packages/Package Control.sublime-package"
  echo "Package control installed."
fi


if [[ -e "$SUBLIME_TEXT/Packages/User/Package Control.sublime-settings" ]]; then
  echo "Package control settings already installed."
else
  echo "Installing package control settings..."
  mkdir -p "$SUBLIME_TEXT/Packages/User/"
  cp "Package Control.sublime-settings" "$SUBLIME_TEXT/Packages/User/"
  echo "Package control settings installed."
fi
