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
brew "tree-sitter"             # nvim-treesitter (main) needs the CLI
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

# ---- Browser (used by bin/tmux-agent-jump to sync the localhost:300N tab) ----
cask "google-chrome"

# ---- Optional: parallel-agent orchestration TUI ----
# Runs on the same tmux + worktree substrate as `dot agents`; opt-in.
# brew "claude-squad"

# ===========================================================================
# relay / peel2 work — only needed on a machine that does peel2 development.
# Safe to delete this whole block on a personal-only machine.
# ===========================================================================

# ---- AWS / cloud ----
brew "awscli"
brew "saml2aws"                       # SAML -> AWS temp creds
brew "docker-credential-helper-ecr"   # docker pull/push against ECR
cask "session-manager-plugin"         # `aws ssm start-session`

# ---- Data / warehouse ----
brew "postgresql@14", restart_service: :changed
brew "redis", restart_service: :changed
brew "libpq"                          # psql / pg gem headers
brew "duckdb"
brew "dolt"                           # git-for-data
brew "csvlens"                        # CLI csv viewer
brew "temporal"                       # workflow engine CLI
brew "astro"                          # Astronomer / Airflow CLI

# ---- i18n / secrets ----
brew "phrase-cli"                     # translation sync
brew "age"                            # file encryption
brew "sops"                           # encrypted config (age/kms backend)

# ---- Optional: nwave workflow that powers the mb-* Claude skills ----
# Requires a Homebrew with `uv`/`npm` bundle support. Uncomment to enable.
# uv  "nwave-ai"
# npm "@shopify/cli"
# npm "@shopify/theme"
