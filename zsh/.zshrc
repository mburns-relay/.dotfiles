# Interactive shell config. Kept modular for discoverability (req 11):
# each concern is a numbered file under ~/.config/zsh/, loaded in order.
for _f in "${XDG_CONFIG_HOME:-$HOME/.config}"/zsh/*.zsh(N); do
  source "$_f"
done
unset _f
