-- Loaded early by LazyVim (after LazyVim's own defaults, so this wins).
-- Leader must be set here, not just in lazy.lua, because LazyVim's options
-- step resets mapleader to <space> otherwise.
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- LazyVim already sets many good defaults (2-space, clipboard=unnamedplus,
-- number, etc.); here we keep the few personal prefs from the old init.vim.
local opt = vim.opt

opt.scrolloff = 8         -- old config used 8 (LazyVim default is 4)
opt.sidescrolloff = 15
opt.wrap = false
opt.linebreak = true
opt.swapfile = false      -- old config: no swap/backup
opt.backup = false
opt.writebackup = false
opt.list = true
opt.listchars = { tab = "▸ ", trail = "·" }
opt.mouse = "nir"         -- old config: mouse in normal/insert/replace, not visual
