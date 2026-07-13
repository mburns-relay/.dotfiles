-- Minimal, self-contained RSpec runner (Lua port of the old vimscript helpers).
-- Reuses a single spec terminal split; wide screens get a vertical split.
local M = {}
local state = { buf = nil, win = nil }

local function run(cmd)
  if vim.bo.modified then vim.cmd("silent write") end

  -- Drop the previous spec terminal, if any.
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
  end

  local from = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_width(0) > 160 then
    vim.cmd("botright vsplit"); vim.cmd("vertical resize 90")
  else
    vim.cmd("botright split"); vim.cmd("resize 15")
  end
  vim.cmd("terminal " .. cmd)
  state.buf = vim.api.nvim_get_current_buf()
  state.win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_var(state.win, "is_spec_terminal", true)
  vim.cmd("startinsert")
  vim.api.nvim_set_current_win(from) -- return focus to the editor
end

local function guard()
  local f = vim.fn.expand("%:p")
  if not f:match("_spec%.rb$") then
    vim.notify("Not a spec file", vim.log.levels.WARN)
    return nil
  end
  return f
end

function M.file()
  local f = guard(); if f then run("bundle exec rspec " .. vim.fn.shellescape(f)) end
end

function M.line()
  local f = guard(); if f then run("bundle exec rspec " .. vim.fn.shellescape(f) .. ":" .. vim.fn.line(".")) end
end

function M.jump()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_set_current_win(state.win); vim.cmd("startinsert")
  else
    vim.notify("No spec terminal — run ,sf or ,sl first", vim.log.levels.INFO)
  end
end

return M
