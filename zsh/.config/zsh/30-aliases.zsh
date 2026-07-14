# --- Modern replacements ---
if command -v eza >/dev/null; then
  alias ls='eza --group-directories-first'
  alias ll='eza -l --git --group-directories-first'
  alias la='eza -la --git --group-directories-first'
  alias lt='eza --tree --level=2'
fi
command -v bat >/dev/null && alias cat='bat --paging=never'
alias lh='ls -alt | head'

# --- Awk column shortcuts (carried over) ---
alias A1="awk '{print \$1}'"
alias A2="awk '{print \$2}'"
alias A3="awk '{print \$3}'"
alias A4="awk '{print \$4}'"
alias A5="awk '{print \$5}'"
alias A6="awk '{print \$6}'"
alias A7="awk '{print \$7}'"
alias A8="awk '{print \$8}'"
alias A9="awk '{print \$9}'"

# --- Git (carried over) ---
alias gdmb='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'
alias gcane='git commit --amend --no-edit'
alias gfap='git fetch --all --prune'

# --- Homebrew maintenance ---
alias brewu='brew update && brew upgrade && brew cleanup && brew doctor'

# --- Config meta (YADR-style) ---
alias ae="${EDITOR:-nvim} ${XDG_CONFIG_HOME:-$HOME/.config}/zsh"  # alias edit (opens the zsh config dir)
alias ar='source ~/.zshrc'                                        # alias reload

alias vim='nvim'
