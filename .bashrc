#!/bin/bash


# Define path
export PATH="$HOME/local/bin:$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH"

# If not running interactively, don't do anything else
[[ -z "$PS1" ]] && return

# Ensure readline is configured
[[ -r "$HOME/.inputrc" ]] && export INPUTRC="$HOME/.inputrc"

# Setup python environment
export PYTHONSTARTUP="$HOME/.pystartup"
which pyenv > /dev/null && eval "$(pyenv init -)"
# Define path for system python user packages (lower priority)
system_python_version=$(/usr/bin/python -V 2>&1 | cut -c 8-10)
export PATH="$PATH:$HOME/Library/Python/${system_python_version}/bin"
# Define path for pyenv python user packages (higher priority)
export PATH="$HOME/.local/bin:$PATH"

# Setup ruby environment
which rbenv > /dev/null && eval "$(rbenv init -)"

# Setup go environment
export GOENV_GOPATH_PREFIX="$HOME/.go"
which goenv > /dev/null && eval "$(goenv init -)"
# Define path for go packages
export PATH="$GOPATH/bin:$PATH"


# Prompt customization is done below, using a custom function

# Set the number of EOFs to receive on the commandline before exiting
export IGNOREEOF=2

# Prevent ctrl-s from freezing terminal output.
stty -ixon

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Correct minor spelling errors for directory expansion
shopt -s cdspell

# Append the session's history to file
shopt -s histappend

# Keep a really long history session.
export HISTFILESIZE=100000

# Ignore both commands that start with spaces (ignorespace) and
# duplicate commands (ignoredups) when saving to history
export HISTCONTROL=ignoreboth

# Ignore files with the following suffixes when doing tab completion.
export FIGNORE="~:.git:.o:.pyc:.svn:RCS:CVS"

# Set colors for ls  (FreeBSD/Mac OS X)
#
# COLORS
# a     black
# b     red
# c     green
# d     brown
# e     blue
# f     magenta
# g     cyan
# h     light grey
# A     bold black, usually shows up as dark grey
# B     bold red
# C     bold green
# D     bold brown, usually shows up as yellow
# E     bold blue
# F     bold magenta
# G     bold cyan
# H     bold light grey; looks like bright white
# x     default foreground or background
# ORDER
# 1    directory
# 2    symbolic link
# 3    socket
# 4    pipe
# 5    executable
# 6    block special
# 7    character special
# 8    executable with setuid bit set
# 9    executable with setgid bit set
# 10   directory writable to others, with sticky bit
# 11   directory writable to others, without sticky bit
export LSCOLORS="gxfxcxdxbxegedabagacad"
export CLICOLOR=1

# Set colors for ls  (GNU/Linux)
#
# COLORS
#  0        to restore default color
#  1        for brighter colors
#  4        for underlined text
#  5        for flashing text
# 30        for black foreground
# 31        for red foreground
# 32        for green foreground
# 33        for yellow (or brown) foreground
# 34        for blue foreground
# 35        for purple foreground
# 36        for cyan foreground
# 37        for white (or gray) foreground
# 40        for black background
# 41        for red background
# 42        for green background
# 43        for yellow (or brown) background
# 44        for blue background
# 45        for purple background
# 46        for cyan background
# 47        for white (or gray) background
# VARIABLES
# no        0              Normal (non-filename) text
# fi        0              Regular file
# di        32             Directory
# ln        36             Symbolic link
# pi        31             Named pipe (FIFO)
# so        33             Socket
# bd        44;37          Block device
# cd        44;37          Character device
# ex        35             Executable file
# mi        (none)         Missing file (defaults to fi)
# or        (none)         Orphanned symbolic link (defaults to ln)
# lc        \e[            Left code
# rc        m              Right code
# ec        (none)         End code (replaces lc+no+rc)
export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31"

# Make less behave better
# F: quit if fit on one screen
# J: show status column
# M: use a very verbose prompt
# R: show & keep track of escape sequences (colors)
# W: mark current position for moves > 1 line
# X: preven termcap init (i.e. prevent screen clearing)
# x: set # spaces per tab
export LESS="-FJMRWX -x4"

# Make man behave better: use less with above config and add
# s: squeeze consequtive blank lines into one
export PAGER="less -FJMRWXs -x4"

# Set short version of hostname
HOST=$(hostname | tr A-Z a-z | cut -d. -f1-2)
export HOST

# Set the default editor
export EDITOR="zed -w"

# Install custom functions and aliases
if [[ -r "$HOME/.bash_aliases" ]]; then
  source $HOME/.bash_aliases
fi

# Initializing a SSH agent manually is no longer needed.
# check_ssh_agent || init_ssh_agent
add_ssh_keys

# Enable programmable tab completion
if which brew 2>&1 > /dev/null && [[ -f "$(brew --prefix)/etc/bash_completion" ]]; then
  source $(brew --prefix)/etc/bash_completion
elif [[ -r "/usr/local/etc/bash_completion" ]]; then
  source /usr/local/etc/bash_completion
elif [[ -r "$HOME/.bash_completion" ]]; then
  source $HOME/.bash_completion
fi

# Set primary prompt
prompt_customize yellow
