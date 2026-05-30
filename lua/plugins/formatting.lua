return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      markdown = { "prettier" },
    },
    formatters = {
      prettier = {
        -- prefer local prettier over global
        command = function()
          local local_prettier = vim.fn.findfile("node_modules/.bin/prettier", vim.fn.getcwd() .. ";")
          if local_prettier ~= "" then
            return local_prettier
          end
          return "prettier"
        end,
      },
    },
  },
}
