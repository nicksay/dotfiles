# Required options
setopt prompt_subst

# Required modules
zmodload zsh/datetime
autoload -U add-zsh-hook
autoload -U vcs_info

# Configure vcs_info
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information
#   %b  current branch
#   %a  current action (rebase/merge)
#   %s  current version control system
#   %R  full path of the root directory of the repository
#   %r  name of the root directory of the repository
#   %S  current path relative to the repository root directory
#   %m  misc: Git shows in-progress rebase patch info
#   %u  show unstaged changes in the repository
#   %c  show staged changes in the repository
zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:*' max-exports 2
# stagedstr: Used in %c if there are staged changes.
zstyle ':vcs_info:*' stagedstr "%F{green}󰦒%f"
# unstagedstr: Used in %u if there are unstaged changes.
zstyle ':vcs_info:*' unstagedstr '%F{red}󱈸%f'
# formats: A list of formats, populated to vcs_info_msg_0_, ... vcs_info_msg_N_.
zstyle ':vcs_info:*' formats "$FX[bold]:%r$FX[no-bold]/%S" ":%b %u%c"
# actionformats: A list of formats used if there is a special action going on
# in your current repository; like an interactive rebase or a merge conflict.
zstyle ':vcs_info:*' actionformats "$FX[bold]:%r$FX[no-bold]/%S" ":%b %u%c (%a)"
# nvcsformats: A list of formats used if there's no detected version control
# sytem or if vcs_info was disabled.
zstyle ':vcs_info:*' nvcsformats "%~" ""

# Set up command timer
_nicksay_prompt_start_timer() {
  _nicksay_prompt_timer="$EPOCHREALTIME"
}
_nicksay_prompt_stop_timer() {
  local stop="$EPOCHREALTIME"
  local start="${_nicksay_prompt_timer:-$stop}"
  local elapsed=$((stop - start))
  if (( elapsed > 3.0 )); then
    local mins=$(printf '%d' $(($elapsed / 60)))
    local secs=$(printf '%.1f' $(($elapsed - 60 * mins)))
    local duration="${mins}m${secs}s"
    _nicksay_prompt_duration="${duration#0m}"
  else
    _nicksay_prompt_duration=""
  fi
  unset _nicksay_prompt_timer # Reset timer.
}

# Print prompt info line
_nicksay_prompt_info() {
  local left="\n"
  # Host: Only show user@hostname if connected via SSH.
  if [[ -n $SSH_CONNECTION ]]; then
    left+="%F{yellow}"
    left+="%n@"  # %n = $USERNAME.
    left+="%2m " # %m = Hostname up to N components.
    left+="%f"
  fi
  # VCS Repo and Directory (see vcs_info formats)
  left+="%F{blue}"
  left+="${vcs_info_msg_0_%%/.}"
  # VCS Branch and Status (see vcs_info formats)
  if [[ -n $vcs_info_msg_1_ ]]; then
    if (( $(echotc Co) >= 256 )); then
        left+="%F{247}"  # light grey, if supported
    else
        left+="%F{default}"
    fi
    left+=" $vcs_info_msg_1_"
  fi
  left+="%f"
  # Print the left prompt info
  print -P "$left"

  local right=""
  # Command timer duration
  if [[ -n $_nicksay_prompt_duration ]]; then
    right+="%F{yellow}"
    right+="/${_nicksay_prompt_duration} "
    right+="%f"
  fi
  # Date/Time
  if (( $(echotc Co) >= 256 )); then
      right+="%F{247}"  # light grey, if supported
  else
      right+="%F{default}"
  fi
  right+="[%T]"  # %T = Current time of day, in 24-hour format.
  right+="%f"
  # Print the right prompt info
  local right_str="$(print -P $right | perl -pe 's/\e\[\d*(;\d*)*m//g')"
  local cols=$((COLUMNS - ${#right_str}))
  # Terminal codes:
  # \e[1A	Moves the cursor 1 cell up
  # \e[1B	Moves the cursor 1 cell down
  # \e[1C	Moves the cursor 1 cell forward
  # \e[1D	Moves the cursor 1 cell back
  # \e[1G Moves the cursor to column 1
  print -P "\e[1A\e[${cols}G $right"
}

# Hooks for prompt info line
_nicksay_prompt_preexec() {
  _nicksay_prompt_start_timer
}
_nicksay_prompt_precmd() {
  _nicksay_prompt_stop_timer
  vcs_info
  _nicksay_prompt_info
}
add-zsh-hook preexec _nicksay_prompt_preexec
add-zsh-hook precmd _nicksay_prompt_precmd

_nicksay_prompt_1() {
  local line=""
  line+="%(?.$FX[bold]%F{green}.$FX[bold]%F{red})"
  line+="❯"
  line+="$FX[no-bold]%f"
  line+=" "
  print "$line"
}

_nicksay_prompt_2() {
  local line=""
  line+="%F{8}"
  line+="… "
  line+="%(1_.%_ .%_)"
  line+="%f"
  print -n "$line"
  _nicksay_prompt_1
}

PROMPT="$(_nicksay_prompt_1)"
PROMPT2="$(_nicksay_prompt_2)"
