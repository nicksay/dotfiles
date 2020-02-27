# Add the local homebrew directory for zsh-completions to FPATH.
() {
  local dir="${1:h}/../../../../local/share/zsh-completions"
  fpath+="${dir:A}"
} "$0"
