#!/bin/bash
##
# Bash Aliases and Functions
##


# Command Abbreviations & Synonyms
alias ..='cd ..'
alias cd..='cd ..'
function mkcd() { mkdir -p "$1" && cd "$1"; }
alias e='code'
alias py='python'
alias more='less'
alias q='exit'
alias where='type -a'
alias sym='ln -s'
alias launch='open -a'
function quit() { osascript -e "tell app \"$1\" to quit"; }

# List Convenience
# l = quick, ll = long, a = .*, ? = search mode
alias   l='ls -G -vF'
alias   la='ls -G -vAF'
alias   l?='ls -G -dvAF'
alias   ll='ls -G -lvhF'
alias   lla='ls -G -lavhF'
alias   ll?='ls -G -ldavhF'

# Prompt Customization
function _prompt_time() {
  date '+%-k:%M:%S'
}
function _prompt_date() {
  date '+%b %d %Z'
}
function _prompt_host() {
  local user_and_host="[\u@\h]"
  if [[ $USER == "nicksay" ]]; then
    user_and_host=${user_and_host//\\u@/}
  fi
  if [[ -n $HOST ]]; then
    user_and_host=${user_and_host//\\h/${HOST}}  ## set in .bashrc
  fi
  echo "$user_and_host"
}
function _prompt_dir() {
  local max=${1:-64}
  local dir="${2:-$PWD}"
  if [[ "$dir" =~ ^"$HOME" ]]; then
    dir="~${dir#$HOME}"
  fi
  max=$(( max - 4 ))  # account for adding ".../" later
  echo "$dir" | awk -F/ -v MAX=$max '{
    p="";
    n=NF;
    l=length($n "/");
    while (n > 0 && l < MAX) {
      p=$n "/" p;
      n--;
      l=length($n "/" p);
    }
    if (n > 0) { p=".../" p; }
    printf "%s",p
  }'
}

function _prompt_vcs() {
  if type -t __git_ps1 &> /dev/null; then
    export GIT_PS1_SHOWDIRTYSTATE=1
    if [[ "$PWD/" =~ "/$USER/" ]]; then
      export GIT_CEILING_DIRECTORIES="${PWD%%/$USER/*}/$USER"
    fi
    local gitbranch=$(__git_ps1 "%s")
    if [[ "$gitbranch" ]]; then
      local gitdir="$(basename "$(git rev-parse --show-toplevel)")"
      printf "(%.16s:%.16s)" "$gitdir" "$gitbranch"
    fi
  fi
}
function _prompt_color() {
  case $1 in
    black)        printf '\[\033[30m\]';;
    darkgrey)     printf '\[\033[1;30m\]';;
    lightgrey)    printf '\[\033[37m\]';;
    white)        printf '\[\033[1;37m\]';;
    red)          printf '\[\033[31m\]';;
    brightred)    printf '\[\033[1;31m\]';;
    green)        printf '\[\033[32m\]';;
    brightgreen)  printf '\[\033[1;32m\]';;
    yellow)       printf '\[\033[33m\]';;
    brightyellow) printf '\[\033[1;33m\]';;
    blue)         printf '\[\033[34m\]';;
    brightblue)   printf '\[\033[1;34m\]';;
    purple)       printf '\[\033[35m\]';;
    brightpurple) printf '\[\033[1;35m\]';;
    cyan)         printf '\[\033[36m\]';;
    brightcyan)   printf '\[\033[1;36m\]';;
    *)            printf '\[\033[m\]';;
  esac
}
function prompt_customize() {
  local prompt_color=$1;
  case $TERM in
    xterm* | screen* )
      if [[ $TERM =~ "color" ]]; then
        local color_start="$(_prompt_color $prompt_color)"
        local color_end="$(_prompt_color)"
      fi
      if [[ -r "$HOME/.bash_command_timer.sh" ]]; then
        source "$HOME/.bash_command_timer.sh"
      fi
      if type -t BCTPostCommand &> /dev/null; then
        # If using the bash-command-timer, then use a single-sided prompt.
        local dir_width="\$( echo \$(( COLUMNS - 1 - \$(_prompt_host | wc -c) - \$(_prompt_vcs | wc -c) )) )"
        local line1="${color_start}\$(_prompt_host) \$(_prompt_vcs)\$(_prompt_dir ${dir_width})${color_end}"
        local line2="\$ "
        PS1="${line1}\n${line2}"
      else
        local left_width="\$( echo \$(( COLUMNS - (COLUMNS / 3) )) )"
        local right_width="\$( echo \$(( COLUMNS / 3 )) )"
        local left_prompt_string="\$(_prompt_time) \$(_prompt_vcs)\$(_prompt_dir)"
        local right_prompt_string="\$(_prompt_date) \$(_prompt_host)"
        # Line 1 contains path and status info.
        local line1_left="\$(printf \"%-*.*s\" $left_width $left_width \"$left_prompt_string\")"
        local line1_right="\$(printf \"%*.*s\" $right_width $right_width \"$right_prompt_string\")"
        local line1="${color_start}${line1_left}${line1_right}${color_end}"
        # Line 2 handles input.
        local line2="\$ "
        PS1="\n${line1}\n${line2}"
      fi
      ;;
    *)
      PS1="${prefix}[\u@\h] \w\$ "
      ;;
  esac
  export PS1;
}

# Process Convenience
alias p='ps cx -o "pid state start time command"'
alias pa='ps cax -o "user pid state start time command"'
alias pl='ps wx -o "pid state start time command"'
alias pla='ps wax -o "user pid state start time command"'
alias pll='ps wwx -o "pid state start time command"'
alias plla='ps wwax -o "user pid state start time command"'
alias p?='p | egrep -i'
alias pa?='pa | egrep -i'
alias pl?='pl | egrep -i'
alias pla?='pla | egrep -i'
alias pll?='pll | egrep -i'
alias plla?='plla | egrep -i'
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
function webloc2url() {
  for src in "$@"; do
    dst="${src/%webloc/url}"
    url=$(strings "$src/rsrc" | fgrep http | head -n 1)
    url="${url/#?http/http}"
    echo -e "[InternetShortcut]\nURL=$url" > "$dst"
    echo "$src  ->  $dst"
  done
}
function hex2rgb() {
  pft='%d'
  for hex in "$@"; do
    hex=$(echo "${hex##*\#}")
    if [[ "${#hex}" = 6 || "${#hex}" = 8 ]]; then
      r=; g=; b=
      format="${pft},${pft},${pft}"
      val="0x${hex:0:2} 0x${hex:2:2} 0x${hex:4:2}"
      if [[ "${#hex}" = 8 ]]; then
        format="${format},${pft}"
        val="$val 0x${hex:6:2}"
      fi
      eval "printf \"$hex >> $format\\\n\" $val"
    fi
  done
}
function rgb2hex() {
  oldIFS=$IFS; IFS=','
  pft='%02x'
  declare -a rgba
  for num in "$@"; do
    rgba=( $num )
    if [[ "${#rgba[@]}" = 3 || "${#rgba[@]}" = 4 ]]; then
      format="${pft}${pft}${pft}"
      val="${rgba[0]} ${rgba[1]} ${rgba[2]}"
      if [[ "${#rgba[@]}" = 4 ]]; then
        format="${format}${pft}"
        val="$val ${rgba[3]}"
      fi
      eval "printf \"$num >> $format\\\n\" $val"
    fi
  done
  IFS=$oldIFS
}

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
  command=( "find" )
  search="-iname"
  while getopts "e" opt "$@"; do
    search="-iregex"
  done
  shift $((OPTIND-1))
  unset OPTSTRING
  unset OPTIND
  unset OPTARG

  if [[ "$#" == "0" ]]; then
    echo "usage: ff -e search_pattern [dir ...]"
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
    while (( "$#" )); do
      command=( "${command[@]}" "$1" )
      shift
    done

  fi
  command=( "${command[@]}" "$search" "$pat" "-print" )

  "${command[@]}"
}
function gr() {
  grep_command=( "egrep" "-rIin" )
  while getopts "clLv" opt "$@"; do
    grep_command=( "${grep_command[@]}" "-$opt" )
  done
  shift $((OPTIND-1))
  unset OPTSTRING
  unset OPTIND
  unset OPTARG

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
      while (( "$#" )); do
        find_command=( "${find_command[@]}" "$1" )
        shift
      done
    else
      find_command=( "find" "." )
    fi
    find_command=( "${find_command[@]}" "-type" "f" "!" "-name" "'*~'" )
    xargs_command=( "xargs" "-n" "100" "-P" "24" )
    xargs_command=( "${xargs_command[@]}" "${grep_command[@]}" )
    # Faster grep using the "C" locale: byte matching not string comparison.
    LC_ALL=C  "${find_command[@]}" | "${xargs_command[@]}" | sort -u
  fi
}

function diffcolor() {
  while read -r; do
    line="$REPLY"
    # escape all backslashes
    line="${line//\\/\\\\}"
    # removed lines in red
    line="${line/#-/\033[31m-}"
    # added lines in green
    line="${line/#+/\033[32m+}"
    # headers in blue/white
    line="${line/#Index: /\033[1;34m\033[47mIndex: }"
    # gaps in white/blue
    line="${line/#@@/\033[44m@@}"
    # print it!
    echo -e "${line}\033[m"
  done
}


alias serve='simplehttp2server'


function check_ssh_agent() {
  agent_status="1"
  env_file=${SSH_ENV-$HOME/.ssh/environment-$HOSTNAME}
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
  fi
  return $status
}
function init_ssh_agent() {
  echo "Initialising new SSH agent..."
  env_file=${SSH_ENV-$HOME/.ssh/environment-$HOSTNAME}
  ssh-agent > "$env_file"
  chmod 600 "$env_file"
  source "$env_file" > /dev/null
}

function add_ssh_keys() {
  # Use a wildcard path to also get names like github_rsa, etc.
  for key in $(ls "$HOME"/.ssh/*_[dr]sa "$HOME"/.ssh/*_ed25519 &>/dev/null); do
      (ssh-add -L | grep -q "$key") || ssh-add "$key"
  done
}
