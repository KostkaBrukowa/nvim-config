return {
  "folke/neoconf.nvim",
  cond = not vim.g.vscode,

  opts = {
    plugins = {
      lspconfig = {
        enabled = false,
      },
      jsonls = {
        enabled = false,
      },
      lua_ls = {
        enabled_for_neovim_config = false,
        enabled = false,
      },
    },
  },
}
