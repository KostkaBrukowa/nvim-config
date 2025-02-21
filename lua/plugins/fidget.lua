return {
  "j-hui/fidget.nvim",
  cond = not vim.g.vscode,
  opts = {
    progress = {
      ignore = {
        "null-ls",
      },
      display = {
        render_limit = 1, -- How many LSP messages to show at once
      },
    },
  },
}
