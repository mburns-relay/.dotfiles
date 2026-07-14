#!/usr/bin/env bash
set -euo pipefail

# One-command, idempotent macOS setup. Safe to re-run.
#   ./bootstrap.sh            full setup
#   ./bootstrap.sh --dry-run  show what would happen, change nothing
#   ./bootstrap.sh --unstow   remove all symlinks

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false; UNSTOW=false
for a in "$@"; do
  case "$a" in
    --dry-run) DRY_RUN=true ;;
    --unstow)  UNSTOW=true ;;
    *) echo "unknown flag: $a"; exit 1 ;;
  esac
done

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
step() { echo -e "\n${BLUE}==>${NC} $*"; }
info() { echo -e "${GREEN}  ✓${NC} $*"; }
warn() { echo -e "${YELLOW}  !${NC} $*"; }
run()  { if $DRY_RUN; then echo "    [dry-run] $*"; else eval "$*"; fi; }

[[ "$(uname)" == "Darwin" ]] || { echo "macOS only."; exit 1; }
[[ "$EUID" -ne 0 ]] || { echo "Do not run as root."; exit 1; }

packages() {
  # Topic packages = visible top-level dirs, minus repo meta.
  # Hidden dirs (.git, .claude, .github, …) are never stowed.
  find "$DOTFILES" -mindepth 1 -maxdepth 1 -type d \
    ! -name '.*' ! -name 'docs' -exec basename {} \;
}

# ---------------------------------------------------------------------------
if $UNSTOW; then
  step "Removing symlinks"
  for p in $(packages); do run "stow -d '$DOTFILES' -t '$HOME' -D '$p' || true"; done
  warn "Homebrew packages left installed. Touch ID sudo snippet left in place."
  exit 0
fi

# 1. Homebrew -----------------------------------------------------------------
step "Homebrew"
if ! command -v brew >/dev/null; then
  run '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
fi
if [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
info "brew ready"

# 2. Brewfile -----------------------------------------------------------------
step "Installing packages (brew bundle)"
# Homebrew 6+ refuses BOTH formulae and casks from non-official taps until
# trusted. Trust every third-party tap we use; idempotent to re-trust.
if brew help trust >/dev/null 2>&1; then
  run "brew trust --tap nikitabobko/tap felixkratz/formulae common-fate/granted || true"
fi
run "brew bundle --file '$DOTFILES/Brewfile'"

# 3. Touch ID for sudo (+ inside tmux via pam_reattach) -----------------------
step "Touch ID for sudo"
PAM_REATTACH="$(brew --prefix 2>/dev/null)/lib/pam/pam_reattach.so"
SUDO_LOCAL="/etc/pam.d/sudo_local"
if [[ -f "$SUDO_LOCAL" ]] && grep -q pam_tid.so "$SUDO_LOCAL"; then
  info "already configured"
else
  warn "This step needs your password once; afterwards sudo uses your fingerprint."
  TMP="$(mktemp)"
  { [[ -f "$PAM_REATTACH" ]] && echo "auth       optional       $PAM_REATTACH"; \
    echo "auth       sufficient     pam_tid.so"; } > "$TMP"
  run "sudo tee '$SUDO_LOCAL' < '$TMP' >/dev/null"
  rm -f "$TMP"
  info "wrote $SUDO_LOCAL"
fi

# 3b. macOS defaults ----------------------------------------------------------
step "macOS defaults"
# Auto-hide the native menu bar so sketchybar (position=top) owns the top strip
# instead of overlapping it. The native bar still slides in on hover.
run "defaults write NSGlobalDomain _HIHideMenuBar -bool true"
info "native menu bar set to auto-hide (full effect after next login)"

# 4. Stow topic packages ------------------------------------------------------
step "Linking dotfiles (stow)"
for p in $(packages); do
  if $DRY_RUN; then echo "    [dry-run] stow $p";
  else stow -d "$DOTFILES" -t "$HOME" --restow "$p" 2>/dev/null \
        && info "stowed $p" || warn "conflict in $p — resolve then re-run"; fi
done

# 5. tmux plugin manager ------------------------------------------------------
step "tmux (TPM)"
TPM="$HOME/.config/tmux/plugins/tpm"
[[ -d "$TPM" ]] || run "git clone --depth 1 https://github.com/tmux-plugins/tpm '$TPM'"
info "TPM present ('prefix + I' inside tmux to install plugins)"

# 6. Runtimes -----------------------------------------------------------------
step "Runtimes (mise)"
command -v mise >/dev/null && run "mise install || true"

# 7. Neovim plugins (phase 2 — only if config present) ------------------------
if [[ -e "$HOME/.config/nvim/init.lua" || -e "$HOME/.config/nvim/init.vim" ]]; then
  step "Neovim plugins"
  run "nvim --headless '+Lazy! sync' +qa || true"
fi

# 8. Accessibility (cannot be scripted — TCC is SIP-protected) ----------------
step "Accessibility permissions"
warn "AeroSpace & Karabiner need Accessibility access, which macOS won't grant"
warn "from a script. Opening System Settings — enable them, then enable the"
warn "'Caps -> Esc/Ctrl' rule in Karabiner ▸ Complex Modifications ▸ Add rule."
if ! $DRY_RUN; then
  open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility" || true
  read -r -p "    Press Enter once granted (or to skip)... " _ || true
fi

echo -e "\n${GREEN}Bootstrap complete.${NC} Open a new terminal, then run: ${BLUE}dot doctor${NC}"
