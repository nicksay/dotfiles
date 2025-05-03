#!/bin/zsh

HOMEBREW_PREFIX="/opt/homebrew"
if [[ -x $HOMEBREW_PREFIX/bin/brew ]]; then
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi

export PATH="$HOME/local/bin:$HOME/bin:$PATH"

export FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"

######################## begin oh-my-zsh configuration ########################

# Set oh-my-zsh location.
ZSH="$HOME/.oh-my-zsh"

# Set theme to load.
ZSH_THEME="nicksay"

# Use hyphen-insensitive completion (_ and - will be interchangeable).
HYPHEN_INSENSITIVE="true"

# Change the command execution time stamp shown in the history command output.
# Example formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# Or set a custom format using the strftime format specifications.
HIST_STAMPS="yyyy-mm-dd"

# Plugins to load.
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(
  google-cloud-sdk
  zsh-completions
  zsh-history-substring-search
)
if [[ "$(uname -s)" == "Darwin" ]]; then
  plugins+=(
    one-password
  )
fi

# Ignore warnings about completion directory permissions.
ZSH_DISABLE_COMPFIX=true

# Environnment and aliases are defined in $ZSH/custom.
source "$ZSH/oh-my-zsh.sh"

######################## end oh-my-zsh configuration ########################
