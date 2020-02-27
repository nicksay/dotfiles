# Source the local homebrew file for zsh-history-substring-search.
() {
  local dir="${1:h}/../../../../local/share/zsh-history-substring-search"
  source "${dir:A}/zsh-history-substring-search.zsh"
  # Bind up/down
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  # Bind ctrl-p/ctrl-n
  bindkey -M emacs '^P' history-substring-search-up
  bindkey -M emacs '^N' history-substring-search-down
} "$0"
