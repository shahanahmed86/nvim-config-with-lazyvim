return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
        custom_filter = function(buf_number)
          local name = vim.api.nvim_buf_get_name(buf_number)
          return vim.fn.isdirectory(name) == 0
        end,
      },
    },
  },
}
