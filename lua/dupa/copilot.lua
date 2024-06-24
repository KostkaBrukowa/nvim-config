vim.keymap.set("i", "<Right>", 'copilot#Accept("\\<Right>")', {
  expr = true,
  replace_keycodes = false,
  silent = true,
})
vim.g.copilot_no_tab_map = true
vim.keymap.set("i", "<C-l>", "<Plug>(copilot-next)")
vim.keymap.set("i", "<C-u>", "<Plug>(copilot-previous)")
vim.keymap.set("i", "<C-y>", "<Plug>(copilot-suggest)")
vim.keymap.set("i", "<C-e>", "<Plug>(copilot-cancel)")
