# Source the homebrew file for zsh-history-substring-search.
() {
  if type brew &>/dev/null; then
    source "$(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
    # Bind up/down
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    # Bind ctrl-p/ctrl-n
    bindkey -M emacs '^P' history-substring-search-up
    bindkey -M emacs '^N' history-substring-search-down
  else
    echo "Warning: unable to find 'brew' command when loading 'zsh-history-substring-search.plugin.zsh'." >&2
  fi
} "$0"
