return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pylsp = { enabled = false },
        pyright = {
          settings = {
            pyright = {
              disableOrganizeImports = true, -- ruff handles this
            },
            python = {
              analysis = {
                autoSearchPaths = false,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly", -- only analyse open files, not entire project
              },
            },
          },
        },
      },
    },
  },
}
