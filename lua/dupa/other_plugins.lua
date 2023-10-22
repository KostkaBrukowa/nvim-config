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
require("replacer").setup({ save_on_write = true, rename_files = false })
require("mini.ai").setup()
require("mini.pick").setup()
require("clear-action").setup({
  signs = {
    enable = false,
  },
})
