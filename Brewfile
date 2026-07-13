# Brewfile — declarative package manifest. `brew bundle` installs everything.
# Re-runnable; `brew bundle cleanup` reports anything installed but not listed.

# ---- Taps ----
tap "nikitabobko/tap"          # aerospace
tap "FelixKratz/formulae"      # sketchybar
tap "common-fate/granted"      # granted / assume (AWS)

# ---- Core CLI toolchain ----
brew "stow"                    # symlink manager (topic packages)
brew "chezmoi"                 # templating + secret injection (thin layer)
brew "mise"                    # runtimes: ruby, node, etc.
brew "starship"                # prompt
brew "tmux"                    # multiplexer
brew "neovim"                  # editor
brew "git"
brew "gh"                      # GitHub CLI
brew "jq"

# ---- Modern CLI baseline ----
brew "fzf"
brew "ripgrep"
brew "fd"
brew "bat"
brew "eza"
brew "zoxide"
brew "direnv"
brew "git-delta"               # git pager
brew "lazygit"

# ---- Rails / dev ----
brew "foreman"                 # used by the project's bin/dev

# ---- Secrets / auth ----
brew "pam-reattach"            # Touch ID for sudo *inside tmux*
brew "granted"                 # AWS SSO profile switching (`assume`)
cask "1password-cli"           # optional biometric secret backend (`op`)

# ---- Window management ----
cask "aerospace"               # tiling WM (no SIP disabling)
brew "sketchybar"              # top status bar
cask "karabiner-elements"      # Caps -> Esc/Ctrl

# ---- Terminal + font ----
cask "ghostty"
cask "font-jetbrains-mono-nerd-font"

# ---- Optional: parallel-agent orchestration TUI ----
# Runs on the same tmux + worktree substrate as `dot agents`; opt-in.
# brew "claude-squad"
