local open_mapping = [[<c-`>]]

function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-n>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-e>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-i>", [[<Cmd>wincmd l<CR>]], opts)

  -- Reset tab because its overriden somewhere
  vim.keymap.set("t", "<tab>", "<tab>", opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

return {
  "akinsho/toggleterm.nvim",
  keys = { open_mapping },
  opts = {
    size = 20,
    open_mapping = open_mapping,
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = false,
    insert_mappings = false,
    persist_size = true,
    direction = "horizontal",
    close_on_exit = true,
    shell = vim.o.shell,
    auto_scroll = true, -- automatically scroll to the bottom on terminal output
  },
}
