return {
  "rachartier/tiny-inline-diagnostic.nvim",
  cond = not vim.g.vscode,
  opts = {
    options = {
      show_source = true,
      overflow = {
        mode = "oneline",
      },
    },
    hi = {
      background = "",
    },
    signs = {
      left = "",
      right = "",
      arrow = "   ",
    },
  },
}
