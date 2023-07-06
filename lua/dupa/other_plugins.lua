require("leap").setup({})
require("messages").setup()
require("substitute").setup({})
require("nvim-surround").setup({})
require("refactoring").setup({})
require("local-highlight").setup({})
require("package-info").setup({})
require("allegro-metrum").setup({})
require("eyeliner").setup({
  highlight_on_key = true, -- show highlights only after keypress
  dim = true, -- dim all other characters if set to true (recommended!)
})
require("fidget").setup({})
require("glow").setup({})
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
-- require("lsp-file-operations").setup({
--   debug = false,
-- })

-- local otter = require("otter")
-- otter.dev_setup()

vim.keymap.set(
  "n",
  "<space>fff",
  "<cmd>FzfxFiles<cr>",
  { silent = true, noremap = true, desc = "Search files" }
)
