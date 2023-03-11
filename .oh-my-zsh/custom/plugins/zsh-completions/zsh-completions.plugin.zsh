# Add the homebrew directory for zsh-completions to FPATH.
() {
  if type brew &>/dev/null; then
    export FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"
  else
    echo "Warning: unable to find 'brew' command when loading 'zsh-completions.plugin.zsh'." >&2
  fi
} "$0"
