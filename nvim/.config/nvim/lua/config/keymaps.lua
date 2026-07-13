-- Ported from the old init.vim / settings.vim. LazyVim's own keymaps still apply.
local map = vim.keymap.set

-- Window splits (old: vv / ss / Q)
map("n", "vv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "ss", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "Q", "<cmd>q<cr>", { desc = "Quit window" })

-- Fuzzy finding — old fzf.vim muscle memory, now via fzf-lua (require lazily).
local function fzf(fn)
  return function() require("fzf-lua")[fn]() end
end
map("n", "<C-p>", fzf("files"), { desc = "Find files" })
map("n", "<C-g>", fzf("git_files"), { desc = "Git files" })
map("n", "<C-f>", fzf("live_grep"), { desc = "Live grep (Ag/rg)" })
map("n", "<C-b>", fzf("buffers"), { desc = "Buffers" })
map("n", "<leader>h", fzf("oldfiles"), { desc = "History" })
map("n", "<leader>t", fzf("files"), { desc = "Find files" })
map("n", "<leader>b", fzf("buffers"), { desc = "Buffers" })

-- RSpec runner (old: ,sf ,sl ,st)
map("n", "<leader>sf", function() require("config.rspec").file() end, { desc = "RSpec: current file" })
map("n", "<leader>sl", function() require("config.rspec").line() end, { desc = "RSpec: current line" })
map("n", "<leader>st", function() require("config.rspec").jump() end, { desc = "Jump to spec terminal" })

-- Terminal-mode nav that hands off to smart-splits (old tnoremap <C-hjkl>)
for _, k in ipairs({ "h", "j", "k", "l" }) do
  local dir = ({ h = "left", j = "down", k = "up", l = "right" })[k]
  map("t", "<C-" .. k .. ">",
    "<C-\\><C-n><cmd>lua require('smart-splits').move_cursor_" .. dir .. "()<cr>",
    { desc = "Nav " .. dir .. " from terminal" })
end
