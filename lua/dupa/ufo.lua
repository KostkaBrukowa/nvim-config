vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.api.nvim_set_keymap("n", "zR", '<cmd>lua require("ufo").openAllFolds()<cr>', {})
vim.api.nvim_set_keymap("n", "zM", '<cmd>lua require("ufo").closeAllFolds()<cr>', {})

-- require("ufo").setup({
--   close_fold_kinds = {},
-- })
