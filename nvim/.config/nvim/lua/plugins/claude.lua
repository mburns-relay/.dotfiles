-- Ported from the old settings.lua/settings.vim Claude Code integration.
local function send_to_claude(input)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf):match("claude") then
      local chan = vim.b[buf].terminal_job_id
      if chan then vim.fn.chansend(chan, input); return end
    end
  end
  vim.notify("Claude terminal not found", vim.log.levels.WARN)
end

return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = { window = { width = 200 } },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
      -- Quick answers to Claude prompts (old <leader>1/2/3/y/n)
      { "<leader>1", function() send_to_claude("1\n") end, desc = "Claude: 1" },
      { "<leader>2", function() send_to_claude("2\n") end, desc = "Claude: 2" },
      { "<leader>3", function() send_to_claude("3\n") end, desc = "Claude: 3" },
      { "<leader>y", function() send_to_claude("y\n") end, desc = "Claude: yes" },
      { "<leader>n", function() send_to_claude("n\n") end, desc = "Claude: no" },
    },
  },
}
