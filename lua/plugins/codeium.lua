return {
  {
    "Exafunction/codeium.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.api.nvim_set_hl(0, "CodeiumSuggestion", { fg = "#a0a8b8", italic = true })
      require("codeium").setup({
        enable_cmp_source = false,
        virtual_text = {
          enabled = true,
          key_bindings = {
            accept = "<Tab>",
            accept_word = "<C-j>",
            next = "<C-n>",
            prev = "<C-p>",
            dismiss = "<C-]>",
          },
        },
      })
    end,
  },
}
