return {
  {
    "folke/persistence.nvim",
    lazy = false,
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save session" },
      { "<leader>qQ", function() require("persistence").stop() vim.cmd("qa") end, desc = "Quit all without saving session" },
    },
  },
}
