require("messages").setup()
require("substitute").setup({})
require("nvim-surround").setup({})
require("package-info").setup({ autostart = false })
require("allegro-metrum").setup({})
require("tsc").setup({})
require("bqf").setup({})
require("lsp-file-operations").setup({})
vim.cmd("let g:cursorword_disable_filetypes = ['fugitive', 'NvimTree']")
vim.cmd("let g:cursorword_disable_at_startup = v:false")

require("mini.ai").setup({
  n_lines = 500,
})
require("clear-action").setup({ signs = { enable = false } })
require("textcase").setup({})

vim.api.nvim_create_user_command("Eslint", function()
  vim.cmd("compiler eslint | make ./ | copen")
end, {})

vim.api.nvim_create_user_command("EslintPanel", function()
  vim.cmd("compiler jest | make --selectProjects lint | copen")
end, {})

vim.api.nvim_create_user_command("JestPanel", function()
  vim.cmd("compiler jest | make --selectProjects test | copen")
end, {})

vim.api.nvim_create_user_command("Jest", function()
  vim.cmd("compiler jest | make | copen")
end, {})
