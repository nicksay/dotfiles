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
  bibhasdn.unique-lines
  dbaeumer.vscode-eslint
  DevonDCarew.bazel-code
  dmitry-korobchenko.prototxt
  EditorConfig.EditorConfig
  eg2.tslint
  joelday.docthis
  mrcrowl.hg
  ms-python.python
  ms-vscode.cpptools
  rix0rrr.gcl
  stkb.rewrap
  wmaurer.change-case
  xaver.clang-format
  zxh404.vscode-proto3
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
