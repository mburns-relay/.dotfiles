# nvim (phase 2 — LazyVim migration)

This directory is a placeholder. Phase 2 replaces the old vim-plug config with
**LazyVim** and ports the customizations captured in the top-level README:

- `claudecode.nvim` + `snacks.nvim` and the `<leader>a…` Claude mappings
- RSpec runner (`,sf` / `,sl`) + dedicated spec terminal
- Claude-terminal send helpers (`<leader>1/2/3/y/n`) and terminal-mode escapes
- git-blame, fzf, window-split (`vv`/`ss`) mappings
- Ruby: `ruby-lsp` + treesitter + `conform`/`nvim-lint`
- JS/TS: `vtsls` + ESLint + Prettier
- `smart-splits.nvim` for the Ctrl+hjkl nav layer (+ recreated spacer panes)
- Leader stays `,`

Until then, `bootstrap.sh` skips the nvim plugin-sync step (guarded on the
presence of `init.lua`/`init.vim`).
