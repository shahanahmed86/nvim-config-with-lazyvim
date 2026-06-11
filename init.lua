-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    vim.schedule(function()
      local listed = vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
      end, vim.api.nvim_list_bufs())
      local only_empty = #listed == 1
        and vim.api.nvim_buf_get_name(listed[1]) == ""
        and vim.api.nvim_buf_get_lines(listed[1], 0, -1, false)[1] == ""
      if #listed == 0 or only_empty then
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local wbuf = vim.api.nvim_win_get_buf(win)
          if vim.bo[wbuf].filetype == "snacks_picker_list" then
            vim.api.nvim_win_close(win, true)
            break
          end
        end
        Snacks.dashboard.open()
      end
      if vim.fn.argc() == 0 then
        pcall(function() require("persistence").save() end)
      end
    end)
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  callback = function()
    local argc = vim.fn.argc()
    local is_dir = argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1
    if argc > 0 and not is_dir then
      require("persistence").stop()
      return
    end
    local persistence = require("persistence")
    local session_file = persistence.current()
    local has_session = session_file ~= nil and vim.fn.filereadable(session_file) == 1
    if has_session then
      persistence.load()
      -- wipe leftover [No Name], directory, deleted-file, and out-of-project buffers
      local cwd = vim.fn.getcwd()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.api.nvim_buf_get_name(buf)
        local is_empty = name == ""
        local is_dir_buf = vim.fn.isdirectory(name) == 1
        local is_missing = name ~= "" and vim.fn.filereadable(name) == 0 and vim.fn.isdirectory(name) == 0
        local is_outside_cwd = name ~= "" and not vim.startswith(name, cwd .. "/") and name ~= cwd
        if (is_empty or is_dir_buf or is_missing or is_outside_cwd) and vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
      vim.defer_fn(function()
        local real_bufs = vim.tbl_filter(function(buf)
          local name = vim.api.nvim_buf_get_name(buf)
          return vim.api.nvim_buf_is_valid(buf)
            and vim.bo[buf].buflisted
            and name ~= ""
            and vim.fn.filereadable(name) == 1
        end, vim.api.nvim_list_bufs())
        if #real_bufs > 0 then
          Snacks.explorer.open()
        else
          Snacks.dashboard.open()
        end
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
  end,
})
