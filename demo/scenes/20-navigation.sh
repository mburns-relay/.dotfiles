# title: Navigation — Ctrl-hjkl across tmux + nvim
# shellcheck shell=bash
[[ -n "${FG:-}" ]] || source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

banner "Navigation" "🧭"
say "Inside the terminal, one keymap crosses tmux panes AND nvim splits — no prefix,"
say "no thinking about which program has focus. smart-splits.nvim routes it."
note "Ctrl+h/j/k/l  (= Caps+hjkl, thanks to Karabiner)  moves across the split↔pane boundary"
say ""
say "The nvim side of that seam:"
run "bat --style=plain $DOTFILES/nvim/.config/nvim/lua/plugins/smart-splits.lua"
say "Same fingers, three layers, two modifiers. Swap tmux for zellij later = a config change."
