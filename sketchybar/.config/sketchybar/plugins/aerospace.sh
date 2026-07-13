#!/usr/bin/env bash
# Highlight the focused AeroSpace workspace. FOCUSED_WORKSPACE comes from the
# aerospace exec-on-workspace-change trigger (see aerospace.toml).
source "$HOME/.config/sketchybar/colors.sh"
wid="${NAME#space.}"
if [ "$wid" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" background.color=$ACCENT label.color=$BAR_COLOR
else
  sketchybar --set "$NAME" background.color=$ITEM_BG label.color=$WHITE
fi
