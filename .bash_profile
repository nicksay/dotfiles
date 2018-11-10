#!/bin/bash

# Setup up iTerm2 shell integration first, so it is available in .bashrc
if [[ -r ~/.iterm2_shell_integration.bash ]]; then
  source ~/.iterm2_shell_integration.bash
fi

# Include .bashrc if it exists
if [[ -r ~/.bashrc ]]; then
  source ~/.bashrc
fi
