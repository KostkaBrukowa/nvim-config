require("messages").setup()
require("substitute").setup({})
require("nvim-surround").setup({})
require("package-info").setup({})
require("allegro-metrum").setup({})
require("fidget").setup()
require("tsc").setup({})
require("bqf").setup({})
require("lsp-file-operations").setup({})
vim.cmd("let g:cursorword_disable_filetypes = ['fugitive', 'NvimTree']")
require("mini.ai").setup()
require("git-conflict").setup()
require("clear-action").setup({
  signs = {
    enable = false,
  },
})
