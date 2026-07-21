# shellcheck shell=bash
# demo/lib.sh — the shared vocabulary every scene speaks.
# Gruvbox truecolor palette mirrors sketchybar/.config/sketchybar/colors.sh.

# Truecolor sequences (Ghostty speaks these fluently).
_fg()  { printf '\033[38;2;%s;%s;%sm' "$1" "$2" "$3"; }
FG=$(_fg 235 219 178)      # ebdbb2
RED=$(_fg 251 73 52)       # fb4934
GREEN=$(_fg 184 187 38)    # b8bb26
YELLOW=$(_fg 250 189 47)   # fabd2f
BLUE=$(_fg 131 165 152)    # 83a598
ORANGE=$(_fg 254 128 25)   # fe8019
GREY=$(_fg 146 131 116)    # 928374
BOLD=$'\033[1m'
DIM=$'\033[2m'
NC=$'\033[0m'

# Per-character narration delay. DEMO_FAST=1 turns it off (recording / re-runs).
DEMO_DELAY="${DEMO_DELAY:-0.012}"

banner() {
  local title="$1" glyph="${2:-}"
  local line="────────────────────────────────────────────────────────"
  printf '\n%s╭%s╮%s\n' "$YELLOW" "$line" "$NC"
  printf '%s│%s %s%-54s%s %s│%s\n' "$YELLOW" "$NC" "$BOLD$ORANGE" "$glyph $title" "$NC" "$YELLOW" "$NC"
  printf '%s╰%s╯%s\n\n' "$YELLOW" "$line" "$NC"
}

# Typewriter narration. Honors DEMO_FAST for instant output.
say() {
  local text="$*"
  if [[ -n "${DEMO_FAST:-}" ]]; then
    printf '%s%s%s\n' "$FG" "$text" "$NC"
    return
  fi
  printf '%s' "$FG"
  local i ch
  for (( i = 0; i < ${#text}; i++ )); do
    ch="${text:i:1}"
    printf '%s' "$ch"
    sleep "$DEMO_DELAY"
  done
  printf '%s\n' "$NC"
}

note() { printf '%s  %s%s\n' "$DIM$GREY" "$*" "$NC"; }

# Gate the flow: Enter continues, q quits the whole demo (exit 2 → driver stops).
pause() {
  local prompt="${1:-press Enter to continue}"
  printf '%s  ⏎ %s%s' "$DIM$GREY" "$prompt" "$NC"
  local key
  IFS= read -rsn1 key || true
  printf '\r\033[K'
  [[ "$key" == "q" ]] && exit 2
  return 0
}

# Show a command like the Starship prompt, then run it on Enter.
# Missing binary → print dimmed with a note, never execute (graceful degrade).
run() {
  local cmd="$1"
  local bin="${cmd%% *}"
  if ! command -v "$bin" >/dev/null 2>&1; then
    printf '%s❯%s %s%s%s  %s(%s not installed yet)%s\n' \
      "$GREEN" "$NC" "$DIM" "$cmd" "$NC" "$DIM$GREY" "$bin" "$NC"
    return 0
  fi
  printf '%s❯%s %s%s%s' "$GREEN" "$NC" "$FG" "$cmd" "$NC"
  local key
  IFS= read -rsn1 key || true
  [[ "$key" == "q" ]] && { printf '\n'; exit 2; }
  printf '\n'
  eval "$cmd" || true
  printf '\n'
}
