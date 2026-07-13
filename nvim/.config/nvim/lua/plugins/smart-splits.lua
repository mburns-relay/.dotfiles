-- The terminal layer of the Ctrl+hjkl (= Caps+hjkl) nav model. Auto-detects
-- tmux and hands off at split edges to the matching tmux bindings in tmux.conf.
return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  opts = { at_edge = "stop" },
  keys = {
    { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Focus left" },
    { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Focus down" },
    { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Focus up" },
    { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Focus right" },
  },
}
