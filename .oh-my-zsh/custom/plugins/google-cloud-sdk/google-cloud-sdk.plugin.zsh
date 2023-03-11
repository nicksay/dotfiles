# Source the homebrew file for google-cloud-sdk.
() {
  if type brew &>/dev/null; then
    source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  else
    echo "Warning: unable to find 'brew' command when loading 'google-cloud-sdk.plugin.zsh'." >&2
  fi
} "$0"
