-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Restore H and L to native vim behavior (top/bottom of screen)
vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")

-- Remove LazyVim's default ]b/[b buffer navigation
vim.keymap.del("n", "]b")
vim.keymap.del("n", "[b")

-- Buffer navigation
vim.keymap.set("n", "<leader>bf", "<cmd>bfirst<cr>", { desc = "First buffer" })
vim.keymap.set("n", "<leader>bl", "<cmd>blast<cr>", { desc = "Last buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })
vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
-- Paste over selection without overwriting the yank register
vim.keymap.set("x", "p", '"_dP', { desc = "Paste without yanking replaced text" })

-- Focus diagnostic float to allow selecting/copying text
vim.keymap.set("n", "<leader>df", function()
  local _, winid = vim.diagnostic.open_float({ focus = false, scope = "cursor" })
  if winid then
    vim.api.nvim_set_current_win(winid)
  end
end, { desc = "Focus diagnostic float" })

-- Toggle background transparency
local transparent = true
vim.keymap.set("n", "<leader>bg", function()
  transparent = not transparent
  require("tokyonight").setup({ transparent = transparent, styles = { sidebars = transparent and "transparent" or "dark", floats = transparent and "transparent" or "dark" } })
  vim.cmd("colorscheme tokyonight")
end, { desc = "Toggle transparency" })
