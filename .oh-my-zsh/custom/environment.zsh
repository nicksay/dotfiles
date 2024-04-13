#!/bin/zsh

# Setup python environment.
export PYTHONSTARTUP="$HOME/.pystartup"
which pyenv > /dev/null && eval "$(pyenv init -)"
export PYENV_ROOT="$HOME/.pyenv/shims"
export PIPENV_PYTHON="$PYENV_ROOT/python"
export PATH="$PYENV_ROOT:$PATH"
# Define path for system python user packages (lower priority).
system_python_version=$(/usr/bin/python -V 2>&1 | cut -c 8-10)
export PATH="$PATH:$HOME/Library/Python/${system_python_version}/bin"
# Define path for pyenv python user packages (higher priority).
export PATH="$HOME/.local/bin:$PATH"

# Setup ruby environment.
which rbenv > /dev/null && eval "$(rbenv init -)"

# Setup go environment.
export GOENV_GOPATH_PREFIX="$HOME/.go"
which goenv > /dev/null && eval "$(goenv init -)"
# Define path for go packages
export PATH="$GOPATH/bin:$PATH"

# Make less behave better:
#   F: quit if fit on one screen
#   J: show status column
#   M: use a very verbose prompt
#   R: show & keep track of escape sequences (colors)
#   W: mark current position for moves > 1 line
#   X: preven termcap init (i.e. prevent screen clearing)
#   x: set # spaces per tab
export LESS="-FJMRWX -x4"

# Make man behave better: use less with above config and add:
#   s: squeeze consequtive blank lines into one
export PAGER="less -FJMRWXs -x4"

# Set short version of hostname.
export HOST="$(hostname | tr A-Z a-z | cut -d. -f1-2)"

# Set the default editor.
export EDITOR="zed -w"

# Enable iTerm2 shell integration.
if [[ -r "$HOME/.iterm2/shell_integration.zsh" ]]; then
  source "$HOME/.iterm2/shell_integration.zsh"
fi
