#!/bin/bash

# Include .bashrc if it exists
if [[ -r ~/.bashrc ]]; then
  source ~/.bashrc
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
