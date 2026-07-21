# title: Wrap up (nvim slides)
# shellcheck shell=bash
[[ -n "${FG:-}" ]] || source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"
: "${DOTFILES:=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

banner "Wrap up" "🎉"
say "Back to the editor for the closing slides."
pause "open the outro in nvim"

nvim "$DOTFILES/demo/slides/outro.md" \
  -c "luafile $DOTFILES/demo/present.lua" \
  -c "lua Present.start()"
