# title: Shell & prompt
# shellcheck shell=bash
[[ -n "${FG:-}" ]] || source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

banner "Shell & Prompt" "🐚"
say "Two-line Starship prompt: full path, red/green ❯ on exit status, git + aws inline."
run "bat --style=plain $DOTFILES/starship/.config/starship.toml"
say "The command sits on its own line — so a triple-click grabs only the command,"
say "never the prompt. OSC 133 marks the zones for exact 'copy last command'."
say ""
say "The modern CLI baseline, all vi-keyed:"
run "eza --tree --level=2 --icons=auto $DOTFILES/zsh"
note "z (zoxide) jumps · bat replaces cat · fzf for history/files · eza for ls"
