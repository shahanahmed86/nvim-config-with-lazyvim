vim.api.nvim_create_autocmd("TermClose", {
  callback = function(ev)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ev.buf) then
        vim.api.nvim_buf_delete(ev.buf, { force = true })
      end
    end)
  end,
})

return {
  "folke/snacks.nvim",
  opts = {
    terminal = {
      win = {
        height = 0.35,
      },
    },
    lazygit = {
      win = {
        width = 0.9,
        height = 0.9,
      },
    },
  },
  keys = {
    {
      "<C-/>",
      function()
        Snacks.terminal.toggle(nil, { win = { height = 0.35 } })
      end,
      desc = "Toggle terminal",
      mode = { "n", "t" },
    },
  },
}
