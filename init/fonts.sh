#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


FONTS="$HOME/Library/Fonts"


if [[ -e "$FONTS/SourceCodePro-Regular.otf" ]]; then
  echo "Fonts already installed."
else
  echo "Installing fonts..."
  source_code_pro_github_api="https://api.github.com/repos/adobe-fonts/source-code-pro/releases/latest"
  source_code_pro_url=$(curl -s "$source_code_pro_github_api" \
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
fi
