#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


LOCAL="$HOME/local"
CODE="$LOCAL/bin/code"

echo
if [[ ! -e "$CODE" ]]; then
  echo "WARNING: code not found."
  exit
fi


echo "Installing code extensions..."
extensions="
  AndrsDC.base16-themes
  dbaeumer.vscode-eslint
  donjayamanne.python
  eg2.tslint
  joelday.docthis
  ms-vscode.cpptools
"
for ext in $extensions; do
  if "$CODE" --list-extensions | egrep -q "^$ext\b"; then
    echo ✓  $ext
  else
    echo 📦  $ext
    "$CODE" --install-extension $ext
  fi
done
echo "Code extensions installed."
