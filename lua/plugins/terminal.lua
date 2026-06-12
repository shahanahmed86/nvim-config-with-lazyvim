vim.api.nvim_create_autocmd("TermClose", {
  callback = function(ev)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ev.buf) then
        vim.api.nvim_buf_delete(ev.buf, { force = true })
      end
    end)
  end,
})

local function pick_dir_and_open(cmd, prompt)
  local cwd = vim.fn.getcwd()
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(cwd) .. " rev-parse --show-toplevel")[1]
  local has_git = vim.v.shell_error == 0 and git_root ~= nil and git_root ~= ""

  local items = {}
  if has_git and git_root ~= cwd then
    table.insert(items, { label = "Current directory: " .. cwd, path = cwd })
    table.insert(items, { label = "Git root: " .. git_root, path = git_root })
  else
    table.insert(items, { label = "Current directory: " .. cwd, path = cwd })
  end
  table.insert(items, { label = "Enter custom path...", path = nil })

  vim.ui.select(items, {
    prompt = prompt,
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end
    if choice.path then
      Snacks.terminal.toggle(cmd, { cwd = choice.path, win = { position = "float", height = 0.9, width = 0.9, border = "rounded" } })
    else
      vim.ui.input({ prompt = "Path: ", default = cwd, completion = "dir" }, function(input)
        if input and input ~= "" then
          Snacks.terminal.toggle(cmd, { cwd = input, win = { position = "float", height = 0.9, width = 0.9, border = "rounded" } })
        end
      end)
    end
  end)
end

return {
  "folke/snacks.nvim",
  opts = {
    bigfile = { enabled = false },
    terminal = {
      win = {
        position = "float",
        height = 0.9,
        width = 0.9,
        border = "rounded",
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
        Snacks.terminal.toggle(nil, { win = { position = "float", height = 0.9, width = 0.9, border = "rounded" } })
      end,
      desc = "Toggle terminal",
      mode = { "n", "t" },
    },
    {
      "<leader>tt",
      function() pick_dir_and_open(nil, "Open terminal in:") end,
      desc = "Toggle terminal (pick dir)",
      mode = "n",
    },
    {
      "<leader>gD",
      function() pick_dir_and_open("lazydocker", "Open lazydocker in:") end,
      desc = "Toggle lazydocker",
      mode = "n",
    },
  },
}
