# title: The parallel-agent fleet
# shellcheck shell=bash
[[ -n "${FG:-}" ]] || source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

banner "Agent Fleet" "🤖"
say "The headline workflow: five Claude Code agents on one repo, fully isolated."
note "dot agents up 5  →  worktrees p1..p5, each a tmux window split: claude | dev"
note "path-derived ports 300N · a copied .env · flip between them with alt+N"
say ""
say "What's running right now:"
run "dot agents ls"
say "Feature work rides the pN home branch: workon <sc-id>  →  finish-task when merged."
