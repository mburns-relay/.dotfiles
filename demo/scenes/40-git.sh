# title: Git UX — delta & biometric signing
# shellcheck shell=bash
[[ -n "${FG:-}" ]] || source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

banner "Git" "🌱"
say "delta pages every diff; lazygit is the TUI; commits are signed with a fingerprint."
run "git -C $DOTFILES show --stat HEAD"
say "The config that wires it up:"
run "bat --style=plain $DOTFILES/git/.config/git/config"
note "signing via the 1Password SSH agent (biometric), Keychain key as fallback"
