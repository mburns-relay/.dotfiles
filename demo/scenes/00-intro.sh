# title: Highlights (nvim slides)
# shellcheck shell=bash
[[ -n "${FG:-}" ]] || source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"
: "${DOTFILES:=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

banner "Highlights" "⚡"
say "A quick high-level pass — presented in the editor itself."
note "space/l next · b back · X runs the slide's code · q returns here"
pause "open the slides in nvim"

nvim "$DOTFILES/demo/slides/highlights.md" \
  -c "luafile $DOTFILES/demo/present.lua" \
  -c "lua Present.start()"
