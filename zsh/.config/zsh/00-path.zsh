# PATH — user bins first, then Homebrew.
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Homebrew (Apple Silicon default; falls back to Intel prefix).
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
