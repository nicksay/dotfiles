#!/bin/zsh

# Location of oh-my-zsh installation, defined first to use in FPATH, etc.
export ZSH="$HOME/.oh-my-zsh"

export PATH="$HOME/local/bin:$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH"

export FPATH="$ZSH/custom/functions:$HOME/local/share/zsh/site-functions:$FPATH"

######################## begin oh-my-zsh configuration ########################

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
plugins=(zsh-completions zsh-history-substring-search)

# Environnment and aliases are defined in $ZSH/custom.
source "$ZSH/oh-my-zsh.sh"

######################## end oh-my-zsh configuration ########################
