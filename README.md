# dotfiles

Modern, fast, biometric-friendly macOS dotfiles built for Ruby/JS/TS development
and for running a **fleet of parallel Claude Code agents** on the same codebase.

This README is the spec. It describes the system as it is intended to work; the
implementation follows the README, not the other way around. If something here
and the code disagree, the README is the bug report.

---

## Highlights

- **One command to set up a fresh Mac.** `./bootstrap.sh` — prompts once for
  Touch ID, then runs unattended and idempotently.
- **Touch ID everywhere it helps:** `sudo`, git commit signing, ssh — and it
  works *inside tmux* (most setups silently don't).
- **Neovim (LazyVim)** tuned for Ruby, JavaScript & TypeScript. ~30 ms startup.
- **One `hjkl` mental model across three layers:** `alt+hjkl` moves between OS
  windows (AeroSpace), `Ctrl+hjkl` (i.e. **Caps+hjkl**) moves between tmux panes
  *and* Neovim splits seamlessly. Same fingers, the modifier picks the zoom.
- **Tiling window manager (AeroSpace)** + a **sketchybar** top bar — no SIP
  disabling required, so it works on a locked-down work Mac.
- **tmux-based agent fleet:** `dot agents up 5` spins up five isolated git
  worktrees, each in its own tmux session running Claude Code.
- **Two-line Starship prompt:** full path, red/green success indicator, and a
  triple-click that copies *only the command*.
- **Vim keybindings** in the shell, readline, `fzf`, and pagers.
- **Secrets stay out of git.** Keychain-first, 1Password-ready, biometric where
  it counts.
- **Managed with GNU Stow** (plain symlinks you can read) + a thin chezmoi layer
  only for the few templated/secret-injected files.

---

## Quick start

```sh
git clone https://github.com/<you>/dotfiles ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

`bootstrap.sh` will:

1. Ask for your password **once** and enable Touch ID for `sudo` (and make it
   work inside tmux). Every later privileged step uses your fingerprint.
2. Install Homebrew if missing, then `brew bundle` the [`Brewfile`](./Brewfile).
3. `stow` every topic into `$HOME` / `$XDG_CONFIG_HOME`.
4. Render the chezmoi-managed templates (machine-specific + secret-injected).
5. Install language runtimes via `mise`.
6. Apply macOS system defaults.
7. Install the Neovim plugin set headlessly so first launch is instant.
8. Prompt you once to grant **Accessibility** to AeroSpace & Karabiner and to
   enable the Caps→Esc/Ctrl rule (the only interactive step — see
   [Permissions](#permissions--idempotency-work-machine-reality)).

It is **idempotent** — safe to re-run any time. Run `./bootstrap.sh --dry-run`
to see what would change without touching anything.

> Platform: **macOS, local use.** No Linux/container support is in scope. Steps
> that need it degrade gracefully in headless/non-interactive runs.

---

## What you get (requirement → tool)

| Area | Tool | Notes |
|---|---|---|
| Package manifest | Homebrew `Brewfile` | Reproducible, declarative |
| Symlink management | **GNU Stow** | One folder per topic; plain symlinks |
| Templating + secret injection | **chezmoi** (thin) | Only for files that need it |
| Runtimes (Ruby, Node, …) | **mise** | Replaces rbenv/nvm/asdf; per-dir versions |
| Window manager | **AeroSpace** | i3-style tiling, no SIP disabling |
| Menu bar | **sketchybar** | Workspace + status indicators |
| Key remapping | **Karabiner-Elements** | Caps = Esc / Ctrl (dual-role) |
| Terminal | **Ghostty** | GPU, OSC 133, Kitty keyboard protocol |
| Multiplexer | **tmux** | Session persistence, SSH-safe, proven |
| Seamless pane/split nav | **smart-splits.nvim** + tmux | Portable `Ctrl-hjkl` |
| Editor | **Neovim / LazyVim** | Ruby + TS extras, lazy-loaded |
| Shell | **zsh** | Vi mode, fast plugin loading |
| Prompt | **Starship** | Two-line, exit-status color, full path |
| Secrets | Keychain → 1Password (`op`) | Multi-backend `secret` command |
| AWS profiles | **granted** (`assume`) | fzf picker, prompt indicator |
| Git UX | `delta`, `lazygit`, biometric signing | |
| CLI baseline | `fzf` `ripgrep` `fd` `bat` `eza` `zoxide` `direnv` | |
| Agent fleet | `dot agents` (worktrees + tmux) | claude-squad optional |

---

## Repository layout

Topic-based, [skwp/yadr](https://github.com/skwp/dotfiles)-style, so anything is
easy to find and easy to delete. Each topic is a self-contained Stow package.

```
~/.dotfiles/
├── README.md            ← you are here (the spec)
├── bootstrap.sh         ← the one command
├── Brewfile             ← everything Homebrew installs
├── bin/                 ← the `dot` CLI + helpers (on $PATH)
│   ├── dot              ← update / help / agents / doctor
│   ├── secret           ← multi-backend secret accessor
│   ├── wt               ← git worktree helper
│   ├── workon           ← start a task: branch + rebase + rename window
│   ├── finish-task      ← reset worktree to main, drop branch, mark <ready>
│   ├── merge-worktrees  ← merge feature branches (unified to pN)
│   ├── web              ← open localhost:300N for the current worktree
│   ├── get-worktree-num ← parse N from a pN worktree
│   ├── rename-tmux-window, kl, replace, exists, rebase-main/master
│   └── … (carried over from the old dotfiles + local-scripts)
├── zsh/                 ← .zshrc, .zshenv, aliases, functions, vi-mode
├── starship/            ← starship.toml (the prompt)
├── aerospace/           ← aerospace.toml (tiling WM, alt+hjkl)
├── sketchybar/          ← top bar: workspaces + status
├── karabiner/           ← Caps→Esc/Ctrl complex-modification asset
├── ghostty/             ← Ghostty config
├── tmux/                ← tmux.conf + plugins (TPM)
├── nvim/                ← LazyVim config (lua/)
├── git/                 ← .gitconfig, .gitignore_global, delta, signing
├── mise/                ← global runtime + tool versions
├── aws/                 ← granted config, profile helpers
├── secrets/             ← chezmoi templates ONLY (no plaintext secrets)
├── macos/               ← defaults.sh (system tweaks)
└── docs/                ← per-topic notes + the keybinding cheatsheet
```

Every topic folder has a short `README.md` explaining what it does and how to
change it. `dot help` surfaces them all.

---

## The `dot` command

A tiny CLI that is the single entry point for living with these dotfiles.

```
dot update     # git pull, brew bundle, restow, mise install, nvim sync
dot help       # searchable cheatsheet of keybindings & commands
dot doctor     # verify the install; report anything missing/broken
dot edit       # open ~/.dotfiles in Neovim
dot agents ... # manage the parallel-agent fleet (see below)
```

---

## Terminal, tmux & navigation

### Ghostty
Configured for a Nerd Font, ligatures, OSC 133 shell integration (see the prompt
section), and the **Kitty keyboard protocol** — which is what lets us bind
`Ctrl-h` distinctly instead of it colliding with Backspace (a classic footgun).

### tmux
- Prefix is `Ctrl-a` (easier reach than the default `Ctrl-b`).
- Session persistence across reboots via `resurrect` + `continuum`.
- Touch ID works inside tmux (see [Secrets & biometrics](#secrets--biometrics)).
- Status line shows session, git branch, and the active AWS profile.

### `hjkl` everywhere: three layers, two modifiers

The same `hjkl` direction moves you at every level of the stack. You never learn
new movement keys — the **modifier** tells the system which "zoom level" to act
on:

| Layer | Scope | Keys |
|---|---|---|
| **OS** — AeroSpace | between app windows / tiles (incl. across monitors) | `alt + h/j/k/l` |
| **Terminal** — tmux + Neovim | between panes *and* splits, seamlessly | `Ctrl + h/j/k/l` |

Three logical layers, only two modifiers — because tmux and Neovim are unified
into one. Navigation inside the terminal routes through **`smart-splits.nvim`**:
`Ctrl+hjkl` crosses the split↔pane boundary transparently, no prefix, no
thinking about which program has focus. (This replaces the old bespoke
`tmux-nav` script; the thin 1-column **spacer panes** you like between splits are
recreated on top of smart-splits so the visual separation survives.)

> **Your Caps Lock makes this sing.** With your Karabiner rule, *held* Caps = Left
> Control, so **`Caps+hjkl`** is the terminal nav layer — and *tapped* Caps =
> Escape for Vim. The entire `Ctrl` layer runs off the home row.

`Ctrl-l` (clear screen) moves to `<prefix> Ctrl-l` in the shell/tmux. Because the
terminal layer routes through smart-splits, swapping tmux for zellij (or a
terminal-native split model) later is a config change, not a rewrite — and
because the OS layer is `alt` (not `Ctrl`), the two never collide. **Low lock-in
by design.**

---

## Window management (AeroSpace + sketchybar)

The OS layer of the `hjkl` model, and the reason it's **AeroSpace** and not
yabai: AeroSpace emulates workspaces without hooking macOS's private APIs, so it
needs **no SIP changes** — it just works on a locked-down / MDM-managed work Mac.

Config lives in `aerospace/aerospace.toml` (XDG-clean at
`~/.config/aerospace/aerospace.toml`).

**Bindings (all on `alt`, so they never touch the terminal's `Ctrl` layer):**

| Keys | Action |
|---|---|
| `alt + h/j/k/l` | focus window left/down/up/right (across monitors) |
| `alt-shift + h/j/k/l` | move the focused window |
| `alt + 1..9` | switch to workspace |
| `alt-shift + 1..9` | move window to workspace |
| `alt-shift-;` | service mode (reload, layout, rebalance) |

**Auto-layout:** `on-window-detected` rules place apps on the right workspace
(e.g. browser → 2, Slack → 4), so windows land where you expect. A workspace can
be dedicated to the **agent fleet** — `dot agents up 5` fills a tiled grid of
Ghostty windows you flip to with one `alt+N`.

### sketchybar (top bar)
A gruvbox-themed tiling-WM status bar: AeroSpace **workspace pills** + front app
on the left; **clock** and **battery** on the right. Config in `sketchybar/`
(`~/.config/sketchybar/`, with `colors.sh` + `plugins/`).

Per-shell status (full path, git branch, exit code, AWS profile) deliberately
stays in the **Starship prompt** and **tmux status line**, where it's accurate —
a menu bar can't see a given shell's exit codes reliably, so req 18's red/green
lives in the prompt, not here.

### Karabiner-Elements (Caps → Esc / Ctrl)
Your existing dual-role rule — *tapped* Caps = **Escape**, *held* Caps = **Left
Control** — is preserved exactly. It's managed as a **complex-modification
asset** (`karabiner/assets/complex_modifications/caps-esc-ctrl.json`) rather than
by symlinking `karabiner.json`, because Karabiner rewrites that file on every GUI
change and would churn git. The asset is stable; `bootstrap.sh` stows it and
prompts you to enable it once in *Karabiner → Complex Modifications*. (If you
ever outgrow one rule, Goku + `karabiner.edn` is the fully-declarative upgrade.)

### Permissions & idempotency (work-machine reality)
- **Accessibility can't be scripted.** macOS's TCC database is SIP-protected, so
  `bootstrap.sh` can't silently grant AeroSpace (or Karabiner) Accessibility
  access. It installs them, opens the right System Settings pane, and **waits
  for you to flip the toggle** — the one intentional interactive beat in an
  otherwise unattended run.
- **`dot doctor`** reports if AeroSpace/Karabiner lack permission, or if an MDM
  profile is blocking them, instead of failing mysteriously.
- Re-running bootstrap never duplicates the Karabiner rule or re-prompts for
  permissions already granted.

## Neovim

Built on **LazyVim** (migrated from the old vim-plug config) — batteries
included, lazy-loaded, discoverable via `:LazyExtras` and which-key popups.

- **Ruby:** `ruby-lsp`, treesitter, `rubocop`/`standard` via `conform` +
  `nvim-lint`. A real upgrade over the previous `vim-rails` + Neomake `mri`
  setup.
- **JS / TS:** `vtsls`, ESLint, Prettier, TSX/JSX treesitter.
- **Fast:** lazy-loading keeps startup ~30 ms; `nvim --startuptime` is tracked
  in `docs/`.
- **Vim keybindings** are the native environment — and the same bindings extend
  to the shell and pagers below. Leader stays `,`.

**Ported from the old config** (kept as first-class Lua):
- `claudecode.nvim` + `snacks.nvim` and all the `<leader>a…` Claude mappings.
- The RSpec runner (`,sf` file / `,sl` line) and its dedicated spec terminal.
- The Claude-terminal send helpers (`<leader>1/2/3/y/n`) and terminal-mode
  escape tweaks.
- git-blame, fzf, and window-split (`vv` / `ss`) mappings.

Config lives in `nvim/lua/` split into `plugins/`, `config/`, and per-language
files. Adding a language is one file.

---

## Shell & prompt

### zsh
- **Vi mode** (`viins`/`vicmd`) with a good cursor-shape indicator.
- Fast plugin loading (no perceptible startup lag).
- `zoxide` (`z`), `eza` aliases for `ls`, `bat` for `cat`, `fzf` history/file
  search — all with vi keybindings.
- Readline (`~/.inputrc`) also set to vi editing mode, so every readline app
  agrees.

### Starship prompt (reqs 18 & 19)
Two-line prompt:

```
~/code/relay/dotfiles  main ✔  aws:relay-dev
❯ ls
```

- **Full path** always shown (`directory` truncation disabled).
- **Success indicator** — the `❯` (and a status segment) turns **green** on
  exit 0, **red** on failure.
- **AWS profile** and **git status** inline.
- **Input on its own line.** This is the trick behind your triple-click
  requirement: because the command lives on a separate line from the prompt,
  triple-click (line-select) grabs *only* `ls`, never the prompt. **OSC 133**
  shell integration (Ghostty + zsh) additionally marks prompt vs command zones,
  so "copy last command" and semantic jumps are exact.

---

## Secrets & biometrics

**No plaintext secrets are ever committed.** `git/` ignores the usual offenders
globally, and `dot doctor` scans for accidental leaks.

### The `secret` command (multi-backend)
One interface surfaces secrets no matter where they live, trying backends in
priority order and returning the first hit:

```sh
secret get OPENAI_API_KEY        # → value
secret set OPENAI_API_KEY        # prompts, stores in the active backend
secret env ~/.config/app/.env    # export a group of vars into the shell
```

Backends:

1. **`op` (1Password CLI)** — used automatically when installed. Native
   *per-access Touch ID*, `op://vault/item/field` references, `op run`/`op
   inject`. This is the target state on the work machine once you have access.
2. **Keychain (login keychain, generic-password class)** — the always-available
   native default *today*. Scriptable via `security`, machine-local, backed by
   the same Keychain + Touch ID infrastructure as Passwords.app.

> **Note on Passwords.app:** it fronts the *iCloud* Keychain for website logins
> and passkeys and is great for interactive use — but it's the wrong store for
> machine API keys (wrong item class, syncs to iCloud, no stable CLI). We use
> the *local login keychain's generic-password* store instead. Same Keychain,
> same fingerprint, correct compartment.

> **Biometric honesty (req 15):** true *per-read* fingerprint prompts come from
> 1Password. Keychain-only gives keychain-*unlock* security (Touch ID/password
> to unlock), not a prompt on every read — unless you enable the optional
> `touchid-secret` LocalAuthentication helper in `bin/`. The `secret` interface
> is identical either way, so moving to `op` later needs no config change.

### File-borne secrets
Anything that must exist *as a file* (a rendered `.env`, ssh snippets) is a
**chezmoi** template. chezmoi injects the value from Keychain/1Password at apply
time — the repo only ever holds the template, never the secret.

### Claude / MCP tokens
Tokens for Claude Code MCP servers (e.g. the Shortcut `SHORTCUT_API_TOKEN`) are
**never written into `~/.claude/settings.json`** — that file is tracked and pushes
to a remote. Instead `settings.json` is a chezmoi template with the token pulled
from Keychain at apply time (or the MCP server is launched via a wrapper that
`secret get`s it). This closes the exact gap that left a live `rw` token sitting
in the working tree of the old dotfiles.

### git commit signing
Commits are signed with the **1Password SSH agent** (biometric) when available,
falling back to a Keychain-stored ssh key — so signing is a fingerprint, not a
passphrase.

---

## AWS profiles

Switching profiles is a fuzzy picker, and the active profile shows in the prompt
and tmux status line:

```sh
assume            # fzf-pick a profile; sets AWS_PROFILE for the session
assume relay-dev  # jump straight to one
```

Backed by **granted** for clean SSO login/refresh. Profiles live in
`aws/config`; credentials never sit in plaintext (SSO or Keychain-backed).

---

## Git worktrees & the parallel-agent fleet

The headline workflow: **five (or more) Claude Code agents working the same repo
in parallel, fully isolated**, each in its own git worktree and tmux session.

This generalizes your existing `tmux-peel2` launcher into a reusable command.

### `dot agents`
```sh
dot agents up 5            # one tmux session; a window per worktree p1..p5,
                           #   each split: `claude` | `dev`
dot agents ls              # list windows, their branch & port
dot agents attach 3        # jump to the p3 window
dot agents diff 3          # review p3's changes
dot agents down            # tear the fleet down
```

Each agent gets:

- Its **own git worktree** — sibling dirs `p1`…`p5` under the project root
  (e.g. `~/relay-commerce/p{N}`), each whose **home branch is its dir name**
  (`p1`…`p5`).
- Its **own tmux window**, split `claude` | `dev`, so your `Ctrl-hjkl` nav works
  normally inside.
- **Path-derived, collision-free ports** (see convention below).
- A copied (not shared) `.env` so agents can't stomp each other's state.

### Branch flow (`workon` / `finish-task`)
Feature work rides on top of the `pN` home branch, driven by the helpers you
already use — and which `~/.claude/CLAUDE.md` tells Claude to run:

- **`workon <sc-id> [desc]`** — rebases `pN` on `origin/main`, cuts
  `sc-<id>-<slug>`, and renames the tmux window to the branch.
- **`finish-task`** — after a merge, resets `pN` to `origin/main`, deletes the
  feature branch, and renames the window `<ready>`.

(`merge-worktrees` is carried over too, but **unified to the `pN` convention** —
the old copy keyed off a stale `w{N}`/`game-of-life-music` scheme.)

### Worktree isolation convention

Isolation is derived from `N` in the `pN` leaf dir, but the two axes work
differently — and only one of them is the dotfiles' job:

| Worktree | Leaf dir | Web port (dotfiles) | Postgres database (app-side) |
|---|---|---|---|
| main | `peel2-rails` | `3000` | `peel2_development` |
| agent 1 | `p1` | `3001` | `peel2_development_w1` |
| agent 2 | `p2` | `3002` | `peel2_development_w2` |
| … | … | … | … |
| agent 5 | `p5` | `3005` | `peel2_development_w5` |

- **Web port = `3000 + N`** — the *only* real port offset, set by a small **zsh
  `dev` wrapper** in the dotfiles (`PORT=$((3000+N))`, rename tmux window, then
  `exec bin/dev`).
- **Postgres = one shared server** (localhost:5432). Each worktree uses a
  distinct **database name** with a `_wN` suffix that `config/database.yml`
  derives *itself* from `File.basename(Rails.root)` — the app self-isolates. Its
  Solid Cache/Queue/Cable all live in that same database via separate
  `schema_search_path`s (true Postgres-for-everything, no Redis).

**So the dotfiles only ever need to export `PORT`.** No DB env var — the app
handles that from its own directory name (already robust from subdirectories,
since it reads `Rails.root`).

> **Small robustness fix:** the `dev` wrapper derives `N` from `basename "$PWD"`,
> which breaks if run from a subdirectory. A worktree-root **`direnv` `.envrc`**
> that exports `PORT` (via `get-worktree-num`) removes that fragility and makes
> the right port visible to *any* tool, not just `dev`. direnv is already in the
> stack (`husk/.envrc`).

### `wt` (the primitive)
`dot agents` is built on `wt`, a thin, fully-owned worktree helper:

```sh
wt new <branch>   # create + set up a worktree, cd into it
wt ls             # list worktrees
wt rm <branch>    # remove a worktree cleanly
```

This primitive has **zero external dependencies** — it's git + tmux + a shell
script you own, so it works forever.

### claude-squad (optional)
If you want a richer TUI (live diff review, pause/resume, session list),
[`claude-squad`](https://github.com/smtg-ai/claude-squad) is in the `Brewfile`
as an **opt-in**. It runs on the *same* tmux + worktree substrate, so it composes
with `dot agents` and can be added or dropped with zero impact on the primitive.

---

## Claude Code integration

- **One-keystroke launch:** a tmux binding opens Claude in a popup/pane from
  anywhere.
- **Prompt awareness:** the prompt/status line reflects when a Claude session is
  active in the pane.
- **Custom commands & habits:** `~/.claude/commands/` is managed here, and the
  docs codify reflexes like prefixing hard tasks with `ultrathink` (deeper
  reasoning) and opting into `ultracode` for multi-agent workflows.
- **Fleet-native:** the worktree tooling above exists specifically so Claude can
  fan out across a codebase without agents tripping over each other.

---

## macOS defaults

`macos/defaults.sh` applies opinionated, reversible system tweaks: fast key
repeat, sane trackpad/Finder behavior, screenshot location, etc. Every setting
is commented with what it does so you can cherry-pick.

---

## Updating & maintenance

```sh
dot update    # pull + brew bundle + restow + mise install + nvim sync
dot doctor    # health check: missing tools, broken symlinks, leaked secrets
```

---

## Backups & what's in git

- The repo is a **normal public-safe git repo** — push it anywhere.
- Secrets are **never** in it (see [Secrets](#secrets--biometrics)); only chezmoi
  *templates* are.
- `dot doctor` fails loudly if a secret ever sneaks into a tracked file.

---

## Testing

Bootstrap idempotency is verified in CI (a clean run, then a second run that must
be a no-op). Because the target is macOS-only, CI covers the OS-agnostic pieces
(stow layout, script linting, chezmoi template rendering with dummy values); the
full run is validated on a real Mac.

---

## Uninstall

```sh
./bootstrap.sh --unstow    # remove all symlinks; leaves Homebrew packages
```

Nothing here modifies system files except the Touch-ID `sudo` snippet, which
`--unstow` also offers to revert.

---

## Design decisions (the "why")

- **Stow + light chezmoi**, not chezmoi-for-everything: symlinks you can read at
  a glance, with templating/secrets only where genuinely needed.
- **tmux, not zellij (yet):** your seamless `Ctrl-hjkl`, copy-mode, SSH, and
  Touch-ID-in-multiplexer needs are exactly where tmux is strongest. Nav routes
  through smart-splits so zellij remains a low-cost future swap.
- **AeroSpace, not yabai:** no SIP disabling, so it survives a managed work Mac.
  `alt` for the OS layer keeps it cleanly separate from the `Ctrl` terminal
  layer, completing the three-tier `hjkl` model without a single collision.
- **Karabiner via asset, not symlinked `karabiner.json`:** the app owns that
  file and rewrites it; managing the complex-modification asset keeps git clean
  and your one dual-role rule intact.
- **Keychain-first, 1Password-ready:** native and free today, biometric-perfect
  the moment `op` lands — with no interface change.
- **Own the primitive, borrow the polish:** `wt`/`dot agents` are yours forever;
  claude-squad is a removable topper.
```
