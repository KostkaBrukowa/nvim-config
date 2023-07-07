vim.o.foldcolumn = "0" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
-- vim.o.fillchars = [[eob:,fold:,foldopen:,foldsep:,foldclose:]]

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.api.nvim_set_keymap("n", "zR", '<cmd>lua require("ufo").openAllFolds()<cr>', {})
vim.api.nvim_set_keymap("n", "zM", '<cmd>lua require("ufo").closeAllFolds()<cr>', {})

require("ufo").setup({
  close_fold_kinds = { "imports" },
})
