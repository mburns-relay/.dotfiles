# ⚡  dotfiles

    Modern, fast, biometric-friendly macOS.
    Built for Ruby / JS / TS — and a fleet of
    parallel Claude Code agents on one codebase.

    This README is the spec. The code follows it.

# One hjkl to rule them all

    Same fingers at every zoom level.
    The modifier picks the layer:

      alt + h j k l        →  OS windows      (AeroSpace)
      Ctrl + h j k l       →  tmux panes + nvim splits
      (Ctrl = held Caps)      (smart-splits, seamless)

    Three layers. Two modifiers. Zero new keys.

# The stack

      package manifest     Homebrew Brewfile
      symlinks             GNU Stow
      secrets / templates  chezmoi (thin)
      runtimes             mise
      window manager       AeroSpace   (no SIP)
      menu bar             sketchybar
      key remap            Karabiner   (Caps → Esc/Ctrl)
      terminal             Ghostty
      multiplexer          tmux
      editor               Neovim / LazyVim
      shell + prompt       zsh + Starship

# One command to set up a Mac

    ./bootstrap.sh

      · Touch ID for sudo — even inside tmux
      · brew bundle the whole Brewfile
      · stow every topic into $HOME
      · render chezmoi secret-injected templates
      · mise install runtimes
      · headless nvim plugin sync

    Idempotent. --dry-run shows the diff.

    (press X to run: dot doctor)

```sh
dot doctor
```

# The agent fleet

    dot agents up 5

      · five isolated git worktrees  p1 … p5
      · a tmux window each:  claude | dev
      · path-derived, collision-free ports  300N
      · a copied .env — agents never stomp

    Five Claudes on one repo, fully isolated.

# Secrets stay out of git

    secret get  OPENAI_API_KEY
    secret set  OPENAI_API_KEY
    secret run  KEY=VAR -- cmd …

    Keychain first → 1Password when present.
    Biometric where it counts. Nothing plaintext.

# Let's take a tour

    Next up, live in the terminal:

      aerospace   ·   navigation   ·   prompt
      git   ·   secrets   ·   the fleet

    q to drop back to the driver →
