#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


HOMEBREW_PREFIX="/opt/homebrew"
CODE="$HOMEBREW_PREFIX/bin/code"

echo
if [[ ! -e "$CODE" ]]; then
  echo "WARNING: code not found."
  exit
fi


echo "Installing code extensions..."
extensions="
  acarreiro.calculate
  adammaras.overtype
  bazelbuild.vscode-bazel
  bibhasdn.unique-lines
  casualjim.gotemplate
  dbaeumer.vscode-eslint
  dmitry-korobchenko.prototxt
  dnut.rewrap-revived
  editorconfig.editorconfig
  eg2.tslint
  goessner.mdmath
  golang.go
  grapecity.gc-excelviewer
  kleber-swf.ocean-dark-extended
  llvm-vs-code-extensions.vscode-clangd
  maelvalais.autoconf
  mrcrowl.hg
  ms-python.python
  ms-python.vscode-pylance
  ms-vscode-remote.remote-ssh
  ms-vscode-remote.remote-ssh-edit
  ms-vscode.cpptools
  ms-vscode.vscode-typescript-tslint-plugin
  redhat.java
  stephanvs.dot
  tintinweb.graphviz-interactive-preview
  visualstudioexptteam.vscodeintellicode
  vscjava.vscode-java-debug
  vscjava.vscode-java-dependency
  vscjava.vscode-java-pack
  vscjava.vscode-java-test
  vscjava.vscode-maven
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
