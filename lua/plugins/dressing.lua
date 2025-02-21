return {
  "stevearc/dressing.nvim",
  cond = not vim.g.vscode,
  opts = {
    input = {
      enabled = true,
    },
    select = {
      telescope = {
        initial_mode = "normal",
      },
    },
  },
}
