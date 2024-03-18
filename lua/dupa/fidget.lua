require("fidget").setup({
  progress = {
    ignore = {
      "null-ls",
    },
    display = {
      render_limit = 1, -- How many LSP messages to show at once
    },
  },
})
