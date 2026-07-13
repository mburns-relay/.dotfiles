-- Leader MUST be set before any plugin defines mappings.
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- LazyVim core + sensible defaults
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Languages (real LSP/treesitter — upgrade over the old vim-rails/neomake)
    { import = "lazyvim.plugins.extras.lang.ruby" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    -- Use fzf-lua so the old <C-p>/<C-g>/<C-f>/<C-b> muscle memory carries over
    { import = "lazyvim.plugins.extras.editor.fzf" },
    -- Our own ports/overrides
    { import = "plugins" },
  },
  defaults = { lazy = false, version = false },
  install = { colorscheme = { "gruvbox", "habamax" } },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = { disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" } },
  },
})
