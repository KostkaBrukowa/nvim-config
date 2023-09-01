require("messages").setup()
require("substitute").setup({})
require("nvim-surround").setup({})
require("local-highlight").setup({})
require("package-info").setup({})
require("allegro-metrum").setup({})
require("fidget").setup({})
require("tsc").setup({})
require("bqf").setup({})
require("mini.ai").setup()
require("barbecue").setup({
  show_dirname = false,
  theme = "tokyonight-moon",
  symbols = {
    separator = "->",
  },
})
require("notify").setup({
  stages = "fade",
  timeout = 1000,
})
require("lsp-file-operations").setup({
  debug = false,
})
