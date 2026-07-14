return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      terminal_colors = true,
      contrast = "hard",  -- classic dark gruvbox background (matches the old vim look)
      bold = true,
      italic = { comments = true, folds = true, strings = false, operators = false },
      transparent_mode = false,
    },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "gruvbox" } },
}
