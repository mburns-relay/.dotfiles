#!/usr/bin/env bash
set -uo pipefail
# demo/demo.sh — self-paced presenter. Sequences scenes/*.sh; some drop into
# nvim slide decks, others run live terminal demos. Enter advances, s skips,
# q quits (from any prompt).

DEMO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DEMO_DIR
export DOTFILES="${DOTFILES:-$(cd "$DEMO_DIR/.." && pwd)}"

# shellcheck source=demo/lib.sh
source "$DEMO_DIR/lib.sh"

scene_files() { ls "$DEMO_DIR"/scenes/*.sh 2>/dev/null | sort; }

scene_title() {
  local t
  t=$(sed -n 's/^# title:[[:space:]]*//p' "$1" | head -1)
  [[ -n "$t" ]] && printf '%s' "$t" || basename "$1" .sh
}

# name|number matcher: 10-aerospace.sh matches "10", "aerospace", "10-aerospace".
scene_match() {
  local q="$1" f base
  for f in $(scene_files); do
    base=$(basename "$f" .sh)
    if [[ "$base" == "$q" || "$base" == *"-$q" || "${base%%-*}" == "$q" || "${base#*-}" == "$q" ]]; then
      printf '%s\n' "$f"
    fi
  done
}

list_scenes() {
  printf '%s%sdot demo%s — scenes\n\n' "$BOLD" "$ORANGE" "$NC"
  local f
  for f in $(scene_files); do
    printf '  %s%-14s%s %s\n' "$YELLOW" "$(basename "$f" .sh)" "$NC" "$(scene_title "$f")"
  done
  printf '\n%srun all: %sdot demo%s   one: %sdot demo aerospace%s   list: %sdot demo --list%s\n' \
    "$DIM$GREY" "$NC$FG" "$DIM$GREY" "$NC$FG" "$DIM$GREY" "$NC$FG" "$NC"
}

play() {
  # shellcheck source=/dev/null
  source "$1"
}

case "${1:-}" in
  --list|-l|ls|list)
    list_scenes
    exit 0
    ;;
  "")
    clear
    for f in $(scene_files); do
      printf '\n%s▸ Next:%s %s   %s[⏎ play · s skip · q quit]%s ' \
        "$BOLD$BLUE" "$NC$FG" "$(scene_title "$f")" "$DIM$GREY" "$NC"
      IFS= read -rsn1 key || true
      printf '\r\033[K'
      case "$key" in
        q) printf '%s  bye 👋%s\n' "$GREY" "$NC"; exit 0 ;;
        s) note "skipped $(scene_title "$f")"; continue ;;
        *) play "$f" ;;
      esac
    done
    printf '\n%s  demo complete 🎉%s\n' "$GREEN" "$NC"
    ;;
  *)
    matches=$(scene_match "$1")
    if [[ -z "$matches" ]]; then
      printf '%sno scene matches "%s"%s\n\n' "$RED" "$1" "$NC" >&2
      list_scenes
      exit 1
    fi
    clear
    for f in $matches; do play "$f"; done
    ;;
esac
