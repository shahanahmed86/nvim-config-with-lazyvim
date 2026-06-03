-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  callback = function()
    local argc = vim.fn.argc()
    local is_dir = argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1
    if argc == 0 or is_dir then
      local persistence = require("persistence")
      local session_file = persistence.current()
      local has_session = session_file ~= nil and vim.fn.filereadable(session_file) == 1

      if has_session then
        persistence.load()
        -- wipe leftover [No Name], directory, and deleted-file buffers
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          local name = vim.api.nvim_buf_get_name(buf)
          local is_empty = name == ""
          local is_dir_buf = vim.fn.isdirectory(name) == 1
          local is_missing = name ~= "" and vim.fn.filereadable(name) == 0 and vim.fn.isdirectory(name) == 0
          if (is_empty or is_dir_buf or is_missing) and vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
        vim.defer_fn(function()
          Snacks.explorer.open()
          -- safely set filetypes for restored buffers without triggering BufRead
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "" then
              local name = vim.api.nvim_buf_get_name(buf)
              local size = vim.fn.getfsize(name)
              if name ~= "" and size > 0 and size < 1.5 * 1024 * 1024 then
                pcall(function()
                  local ft = vim.filetype.match({ filename = name, buf = buf })
                  if ft then
                    vim.bo[buf].filetype = ft
                  end
                end)
              end
            end
          end
        end, 100)
      end
    end
  end,
})
