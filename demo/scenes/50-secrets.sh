# title: Secrets & biometrics
# shellcheck shell=bash
[[ -n "${FG:-}" ]] || source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

banner "Secrets" "🔐"
say "One interface, multiple backends — Keychain first, 1Password when it's installed."
note "secret get KEY · secret set KEY · secret run KEY=VAR -- cmd …"
say ""
say "No plaintext ever hits git. The multi-backend accessor:"
run "bat --style=plain --line-range=1:32 $DOTFILES/bin/.local/bin/secret"
say "And Touch ID works even inside tmux — pam-reattach. Most setups silently don't."
