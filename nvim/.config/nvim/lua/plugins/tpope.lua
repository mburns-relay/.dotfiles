-- The tpope essentials from the old config. vim-surround uses ys/cs/ds, so we
-- disable LazyVim's mini.surround (sa/sd/sr) to keep that muscle memory.
return {
  { "tpope/vim-surround", dependencies = { "tpope/vim-repeat" }, event = "VeryLazy" },
  { "tpope/vim-abolish", event = "VeryLazy" },
  { "tpope/vim-unimpaired", event = "VeryLazy" },
  { "tpope/vim-endwise", event = "VeryLazy" },
  { "tpope/vim-rails", ft = { "ruby", "eruby", "haml", "slim" }, cmd = { "Rails", "A", "AV", "AS" } },
  { "nvim-mini/mini.surround", enabled = false },
}
