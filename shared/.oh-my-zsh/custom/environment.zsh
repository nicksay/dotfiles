#!/bin/zsh

# Setup python environment.
export PYTHONSTARTUP="$HOME/.pystartup"
if which pyenv >/dev/null; then
  PYENV="$(which pyenv)"
elif [ -x "$HOME/.pyenv/bin/pyenv" ]; then
  PYENV="$HOME/.pyenv/bin/pyenv"
fi
if [ -n "$PYENV" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$($PYENV init -)"
else
  echo "Warning: no pyenv found" >&2
fi
# Define path for system python user packages (lower priority).
system_python_version=$(/usr/bin/python -V 2>&1 | cut -c 8-10)
export PATH="$PATH:$HOME/Library/Python/${system_python_version}/bin"
# Define path for pyenv python user packages (higher priority).
export PATH="$HOME/.local/bin:$PATH"

# Setup ruby environment.
if which rbenv >/dev/null; then
  RBENV="$(which rbenv)"
elif [ -x "$HOME/.rbenv/bin/rbenv" ]; then
  RBENV="$HOME/.rbenv/bin/rbenv"
fi
if [ -n "$RBENV" ]; then
  export RBENV_ROOT="$HOME/.rbenv"
  [[ -d $RBENV_ROOT/bin ]] && export PATH="$RBENV_ROOT/bin:$PATH"
  eval "$($RBENV init -)"
else
  echo "Warning: no rbenv found" >&2
fi

# Setup go environment.
export GOENV_GOPATH_PREFIX="$HOME/.go"
if which goenv >/dev/null; then
  GOENV="$(which goenv)"
elif [ -x "$HOME/.goenv/bin/goenv" ]; then
  GOENV="$HOME/.goenv/bin/goenv"
fi
if [ -n "$GOENV" ]; then
  export GOENV_ROOT="$HOME/.goenv"
  [[ -d $GOENV_ROOT/bin ]] && export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$($GOENV init -)"
else
  echo "Warning: no goenv found" >&2
fi
# Define path for go packages.
export PATH="$GOPATH/bin:$PATH"

# Define path for rust packages.
export PATH="$HOME/.cargo/bin:$PATH"

# Setup node enironment.
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

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
if which micro &> /dev/null; then
    export EDITOR="micro"
    if [[ "$COLORTERM" == "truecolor" ]]; then
        export MICRO_TRUECOLOR=1
    fi
else
    export EDITOR="nano"
fi
if [[ -z "$SSH_CONNECTION" ]]; then
    export VISUAL="zed -w"
fi
