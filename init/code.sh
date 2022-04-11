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
  acarreiro.calculate
  adammaras.overtype
  BazelBuild.vscode-bazel
  bibhasdn.unique-lines
  casualjim.gotemplate
  cssho.vscode-svgviewer
  dbaeumer.vscode-eslint
  dmitry-korobchenko.prototxt
  EditorConfig.EditorConfig
  eg2.tslint
  goessner.mdmath
  golang.go
  GrapeCity.gc-excelviewer
  joaompinto.vscode-graphviz
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
  stkb.rewrap
  VisualStudioExptTeam.vscodeintellicode
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
