-- demo/present.lua — a tiny, dependency-free slide renderer.
-- Splits the open markdown buffer on `# ` headings and shows one slide per
-- floating window. space/l/n = next, b/h/p = prev, X = run the slide's ```sh
-- block, q = quit nvim (returns to the demo driver).

local Present = {}
_G.Present = Present

local state = { slides = {}, current = 1, win = nil, buf = nil }

local function parse(lines)
  local slides, cur = {}, nil
  for _, line in ipairs(lines) do
    if line:sub(1, 2) == "# " then
      if cur then table.insert(slides, cur) end
      cur = { title = line:sub(3), body = {} }
    elseif cur then
      table.insert(cur.body, line)
    end
  end
  if cur then table.insert(slides, cur) end
  return slides
end

local function center(text, width)
  local pad = math.floor((width - vim.fn.strdisplaywidth(text)) / 2)
  if pad < 0 then pad = 0 end
  return string.rep(" ", pad) .. text
end

local function render()
  local slide = state.slides[state.current]
  if not slide then return end
  local w = vim.api.nvim_win_get_width(state.win)
  local lines = { "", "", center(slide.title, w), "" }
  for _, l in ipairs(slide.body) do
    table.insert(lines, "  " .. l)
  end
  table.insert(lines, "")
  local footer = ("  %d / %d   ·   space next · b back · X run · q quit")
    :format(state.current, #state.slides)
  vim.bo[state.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_lines(state.buf, -1, -1, false, { "", center(footer, w) })
  vim.bo[state.buf].modifiable = false
end

local function goto_slide(n)
  state.current = math.max(1, math.min(#state.slides, n))
  render()
end

-- Run the first ```sh fenced block on the current slide in a bottom terminal.
local function run_block()
  local slide = state.slides[state.current]
  local code, inside = {}, false
  for _, l in ipairs(slide.body) do
    if l:match("^```") then
      if inside then break end
      inside = true
    elseif inside then
      table.insert(code, l)
    end
  end
  if #code == 0 then return end
  vim.cmd("botright new")
  vim.cmd("resize 14")
  vim.fn.termopen({ "bash", "-lc", table.concat(code, "\n") })
  vim.cmd("startinsert")
end

function Present.start()
  state.slides = parse(vim.api.nvim_buf_get_lines(0, 0, -1, false))
  if #state.slides == 0 then return end
  state.current = 1

  state.buf = vim.api.nvim_create_buf(false, true)
  local cols, rows = vim.o.columns, vim.o.lines
  local width = math.floor(cols * 0.9)
  local height = math.floor(rows * 0.9)
  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((cols - width) / 2),
    row = math.floor((rows - height) / 2),
    style = "minimal",
    border = "rounded",
  })

  vim.wo[state.win].wrap = true
  vim.wo[state.win].winhighlight = "Normal:GruvboxBg0,FloatBorder:GruvboxYellow"
  vim.bo[state.buf].filetype = "markdown"

  local function map(keys, fn)
    for _, k in ipairs(keys) do
      vim.keymap.set("n", k, fn, { buffer = state.buf, silent = true })
    end
  end
  map({ "<space>", "l", "n", "<Right>" }, function() goto_slide(state.current + 1) end)
  map({ "b", "h", "p", "<Left>" }, function() goto_slide(state.current - 1) end)
  map({ "X" }, run_block)
  map({ "q", "<Esc>" }, function() vim.cmd("qa!") end)

  render()
end
