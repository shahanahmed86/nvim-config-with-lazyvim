vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#565f89", bg = "NONE" })
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#565f89", bg = "NONE" })
    vim.diagnostic.config({ float = { border = "rounded" } })
  end,
})

return {
  "folke/noice.nvim",
  opts = {
    views = {
      hover = {
        border = { style = "rounded", padding = { 0, 1 } },
      },
    },
  },
}
