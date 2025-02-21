return {
  "ThePrimeagen/refactoring.nvim",
  cond = not vim.g.vscode,

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = true,
  opts = {},
}
