#!/bin/zsh

# Command Abbreviations & Synonyms
alias ..='cd ..'
alias cd..='cd ..'
function mkcd() { mkdir -p "$1" && cd "$1"; }
alias e='${${(z)EDITOR}[1]}'  # First word of the current $EDITOR value
alias more='less'
alias q='exit'
alias sym='ln -s'
alias launch='open -a'
function quit() { osascript -e "tell app \"$1\" to quit"; }

# List Convenience
# l = quick, ll = long, a = .*, ? = search mode
alias l='ls -G -vF'
alias la='ls -G -vAF'
alias ll='ls -G -lvhF'
alias lla='ls -G -lavhF'

# Process Convenience
alias p='ps cx -o "pid state start time command"'
alias pa='ps cax -o "user pid state start time command"'
alias pl='ps wx -o "pid state start time command"'
alias pla='ps wax -o "user pid state start time command"'
alias pll='ps wwx -o "pid state start time command"'
alias plla='ps wwax -o "user pid state start time command"'
alias die='kill -9'

# File Convenience
function line() { sed -n "$1 p" "$2"; } # line 5 file => show line 5 of file

# Fix Finder Annoyances
alias dsremove='find . -name ".DS_Store" -print -delete'
alias slreset='defaults delete com.apple.Spotlight userHasMovedWindow'

# Misc
alias datestamp='date "+%Y%m%d"'
alias diskspace='df -h | egrep "Size|disk|mapper"'
function range() {
  if $(which seq &> /dev/null); then
    case "$#" in
      0) echo "usage: range [min] max [interval]";;
      1) seq -s' ' $1;;
      2) seq -s' ' $1 $2;;
      *) seq -s' ' $1 $3 $2;;
    esac
  elif $(which jot &> /dev/null); then
    case "$#" in
      0) echo "usage: range [min] max [interval]";;
      1) jot -s' ' $1;;
      2) jot -s' ' $(($2 - $1 + 1)) $1 $2;;
      *) jot -s' ' $(( ( ($2 - $1) / $3) + 1 )) $1 $2 $3;;
    esac
  else
    echo 'unsupported: neither "seq" nor "jot" found'
  fi
}
function zrange() {
  if $(which seq &> /dev/null); then
    case "$#" in
      0) echo "usage: range [min] max [interval]";;
      1) seq -w -s' ' $1;;
      2) seq -w -s' ' $1 $2;;
      *) seq -w -s' ' $1 $3 $2;;
    esac
  elif $(which jot &> /dev/null); then
    case "$#" in
      0) echo "usage: zrange [min] max [interval]";;
      1) jot -s' ' -w"%0${#1}d" $1;;
      2) jot -s' ' -w"%0${#2}d" $(($2 - $1 + 1)) $1 $2;;
      *) jot -s' ' -w"%0${#2}d" $(( ( ($2 - $1) / $3) + 1 )) $1 $2 $3;;
    esac
  else
    echo 'unsupported: neither "seq" nor "jot" found'
  fi
}
function calc() { [[ $1 == *%* ]] && s=0 || s=5; echo "scale=$s; $1" | bc -l; }
function conv() { echo "scale=5; $1 $(units $2 $3)" | head -n 1 | bc -l; }

# Downloading Convenience
function dl() { for a in "$@"; do echo "$a"; curl "$a" -LO; done; }

# Archiving Convenience
function Tgz() {
  [ "$#" = 1 ] && { tar --exclude=".DS_Store" -czvf "$1.tgz" "$1"; return; }
  [[ $1 == *.tgz ]] && n="$1" || n="$1.tgz"; shift
  tar --exclude=".DS_Store" -czvf "$n" "$@";
}
function Untgz() { tar -xzvf "$1"; }
function Tbz() {
  [ "$#" = 1 ] && { tar --exclude=".DS_Store" -cjvf "$1.tbz" "$1"; return; }
  [[ $1 == *.tgz ]] && n="$1" || n="$1.tbz"; shift
  tar --exclude=".DS_Store" -cjvf "$n" "$@";
}
function Untbz() { tar -xjvf "$1"; }
function Zip() {
  [ "$#" = 1 ] && { zip -r "$1" "$1" -x \*.DS_Store; return; }
  n="$1"; shift
  for f in "$@"; do
    [ -e "$n" ] && m='-rg' || m='-r'
    zip $m "$n" "$f" -x \*.DS_Store
  done
}
function Unzip() {
  if fgrep -q '__MACOSX/' "$1"; then
    ditto -xVk --sequesterRsrc "$1" "${2:-.}"
  else
    fgrep -q '.DS_Store' "$1" && x=' -x *.DS_Store'
    unzip "$1"${2:+ -d "$2"}$x
  fi
}

# Searching Convenience
function files() { findbytype f "$1"; }
function folders() { findbytype d "$1"; }
function findbytype() {
  [[ ( "$#" -eq 1 ) || ( -z "$2" ) ]] && DIR='.' || DIR="$2"
  [[ -d "$DIR" ]] && find "$DIR" -type $1 -not -path "$DIR" -print || echo 'invalid dir'
}
function ff() {
  local OPTIND
  command=( "find" )
  search="-iname"
  while getopts "e" opt "$@"; do
    search="-iregex"
  done
  shift $((OPTIND - 1))

  if [[ "$#" == "0" ]]; then
    echo "usage: ff [-e] search_pattern [dir ...]"
    return 1
  fi

  if [[ "$search" == "-iregex" ]]; then
    pat="$1"
  else
    pat="*$1*"
  fi

  if [[ "$#" == "1" ]]; then
    command=( "${command[@]}" "." )
  else
    shift
    while (( $# )); do
      command=( "${command[@]}" "$1" )
      shift
    done
  fi
  command=( "${command[@]}" "$search" "$pat" "-print" )

  "${command[@]}"
}
function gr() {
  local OPTIND
  grep_command=( "egrep" "-rIin" )
  while getopts "clLv" opt "$@"; do
    grep_command=( "${grep_command[@]}" "-$opt" )
  done
  shift $((OPTIND - 1))

  if [[ "$#" == "0" ]]; then
    echo "usage: gr [-clLv] search_regex [dir|file ...]"
    echo "    'gr' is equivalent to 'egrep -rIin'"
    return 1
  fi

  if [[ "$#" == "2" && -f "$2" ]]; then
    grep_command=( "${grep_command[@]}" "$1" "$2" )
    # Faster grep using the "C" locale: byte matching not string comparison.
    LC_ALL=C "${grep_command[@]}"
  else
    # Parallelize grep via find + xargs for faster matching across many files.
    grep_command=( "${grep_command[@]}" "--line-buffered" "$1" )
    shift
    if [[ "$#" != "0" ]]; then
      find_command=( "find" "$1" )
      while (( $# )); do
        find_command=( "${find_command[@]}" "$1" )
        shift
      done
    else
      find_command=( "find" "." )
    fi
    find_command=( "${find_command[@]}" "-type" "f" "!" "-name" "'*~'" "-print0" )
    xargs_command=( "xargs" "-0" "-n" "100" "-P" "24" )
    xargs_command=( "${xargs_command[@]}" "${grep_command[@]}" )
    # Faster grep using the "C" locale: byte matching not string comparison.
    LC_ALL=C "${find_command[@]}" | "${xargs_command[@]}" | sort -u
  fi
}

# SSH Convenience
function check_ssh_agent() {
  agent_status="1"
  env_file="${SSH_ENV-$HOME/.ssh/environment-$(hostname)}"
  if [[ -r "$env_file" ]]; then
    source "$env_file" > /dev/null
    ps -p $SSH_AGENT_PID > /dev/null
    agent_status="$?"
    if [[ "$1" != "-q" ]]; then
      if [[ $agent_status == 0 ]]; then
        echo "SSH agent running as PID $SSH_AGENT_PID"
      else
        echo "SSH agent not running"
      fi
    fi
  else
    echo "SSH agent not running"
  fi
  return $agent_status
}
function init_ssh_agent() {
  echo "Initialising new SSH agent..."
  env_file="${SSH_ENV-$HOME/.ssh/environment-$(hostname)}"
  ssh-agent > "$env_file"
  chmod 600 "$env_file"
  source "$env_file" > /dev/null
}
function add_ssh_keys() {
  # Use a wildcard path to also get names like github_rsa, etc.
  setopt nullglob
  for key in "$(ls $HOME/.ssh/*_[dr]sa $HOME/.ssh/*_ed25519)"; do
    (ssh-add -L | grep -q "$key") || ssh-add "$key"
  done
}
