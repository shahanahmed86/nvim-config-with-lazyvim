-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Restore H and L to native vim behavior (top/bottom of screen)
vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")

-- Remove LazyVim's default ]b/[b buffer navigation
vim.keymap.del("n", "]b")
vim.keymap.del("n", "[b")

-- Buffer navigation
vim.keymap.set("n", "<leader>bf", "<cmd>bfirst<cr>", { desc = "First buffer" })
vim.keymap.set("n", "<leader>bl", "<cmd>blast<cr>", { desc = "Last buffer" })
vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })

-- Claude Code AI
vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })

local function open_claude_with_context(filepath, start_line, end_line)
  local context
  if start_line == end_line then
    context = "@" .. filepath .. ":" .. start_line .. " "
  else
    context = "@" .. filepath .. ":" .. start_line .. "-" .. end_line .. " "
  end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" and vim.api.nvim_buf_get_name(buf):lower():find("claude") then
      vim.api.nvim_set_current_win(win)
      vim.cmd("startinsert")
      vim.api.nvim_feedkeys(context, "t", false)
      return
    end
  end
  vim.cmd("ClaudeCode")
  vim.defer_fn(function()
    vim.api.nvim_feedkeys(context, "t", false)
  end, 300)
end

vim.keymap.set("n", "<leader>al", function()
  local filepath = vim.fn.expand("%:.")
  local line = vim.fn.line(".")
  open_claude_with_context(filepath, line, line)
end, { desc = "Claude: send current line context" })

vim.keymap.set("v", "<leader>al", function()
  local filepath = vim.fn.expand("%:.")
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
  open_claude_with_context(filepath, start_line, end_line)
end, { desc = "Claude: send selection context" })

-- Toggle background transparency
local transparent = true
vim.keymap.set("n", "<leader>bg", function()
  transparent = not transparent
  require("tokyonight").setup({ transparent = transparent, styles = { sidebars = transparent and "transparent" or "dark", floats = transparent and "transparent" or "dark" } })
  vim.cmd("colorscheme tokyonight")
end, { desc = "Toggle transparency" })
