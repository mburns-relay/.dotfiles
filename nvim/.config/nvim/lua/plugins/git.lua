return {
  -- Fugitive for :Git commands (old muscle memory). LazyVim already gives
  -- lazygit (<leader>gg), gitsigns, and <leader>gb blame-line.
  { "tpope/vim-fugitive", cmd = { "Git", "G", "Gdiffsplit", "Gblame" } },

  -- Inline blame virtual text (old git-blame.nvim config), off by default.
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = false,
      message_template = "<summary> • <date> • <author>",
      date_format = "%r",
      highlight_group = "Comment",
    },
    keys = {
      { "<leader>gB", "<cmd>GitBlameToggle<cr>", desc = "Toggle inline blame" },
      { "<leader>go", "<cmd>GitBlameOpenCommitURL<cr>", desc = "Open commit URL" },
      { "<leader>gY", "<cmd>GitBlameCopySHA<cr>", desc = "Copy commit SHA" },
      { "<leader>gf", "<cmd>GitBlameOpenFileURL<cr>", desc = "Open file URL" },
    },
  },
}
