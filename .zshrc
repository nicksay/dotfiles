#!/bin/zsh

export PATH="$HOME/local/bin:$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH"

export FPATH="$HOME/local/share/zsh/site-functions:$FPATH"

######################## begin oh-my-zsh configuration ########################

# Location of oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set oh-my-zsh theme to load.
ZSH_THEME="nicksay"

# Use hyphen-insensitive completion (_ and - will be interchangeable).
HYPHEN_INSENSITIVE="true"

# Change the command execution time stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(zsh-completions zsh-history-substring-search)

# Environnment and aliases are defined as part of oh-my-zsh customization.
source "$ZSH/oh-my-zsh.sh"

######################## end oh-my-zsh configuration ########################
