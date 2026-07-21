# title: AeroSpace — the OS layer of hjkl
# shellcheck shell=bash
[[ -n "${FG:-}" ]] || source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

banner "AeroSpace" "🪟"
say "The OS layer of the hjkl model. Everything's on alt, so it never collides"
say "with the terminal's Ctrl layer. Tiling, no SIP disabling — works on a work Mac."
note "alt+h/j/k/l focus · alt+shift+… move · alt+1..4 workspace · alt+tab back-and-forth"

if command -v aerospace >/dev/null 2>&1 && aerospace list-workspaces --focused >/dev/null 2>&1; then
  say ""
  say "Watch real windows move:"
  run "aerospace workspace 2"
  run "aerospace workspace 1"
  run "aerospace focus right"
  run "aerospace focus left"
  run "aerospace list-workspaces --all"
else
  note "(AeroSpace not running — showing the config instead)"
  run "bat --style=plain --line-range=20:52 $DOTFILES/aerospace/.config/aerospace/aerospace.toml"
fi
