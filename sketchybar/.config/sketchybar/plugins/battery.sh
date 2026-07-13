#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"
info=$(pmset -g batt)
pct=$(echo "$info" | grep -Eo '[0-9]+%' | tr -d '%')
[ -z "$pct" ] && exit 0

if echo "$info" | grep -q 'AC Power'; then icon="󰂄"; else icon="󰁹"; fi
color=$WHITE
[ "$pct" -le 20 ] && color=$RED
sketchybar --set battery icon="$icon" icon.color=$color label="${pct}%"
