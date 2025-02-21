return {
  "petertriho/nvim-scrollbar",
  cond = not vim.g.vscode,

  opts = {
    marks = {
      Error = {
        text = { "▬", "=" },
      },
      Warn = {
        text = { "▬", "=" },
      },
      Info = {
        text = { "▬", "=" },
      },
      Hint = {
        text = { "▬", "=" },
      },
    },
  },
}
