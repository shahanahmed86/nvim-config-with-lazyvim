-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  callback = function()
    local argc = vim.fn.argc()
    local is_dir = argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1
    if argc == 0 or is_dir then
      require("persistence").load()
      -- wipe leftover [No Name] and directory buffers created before session loaded
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.api.nvim_buf_get_name(buf)
        local is_empty = name == ""
        local is_dir_buf = vim.fn.isdirectory(name) == 1
        if (is_empty or is_dir_buf) and vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
      vim.schedule(function()
        Snacks.explorer.open()
      end)
    end
  end,
})
