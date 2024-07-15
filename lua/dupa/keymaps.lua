local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
local fn = vim.fn

vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("", "<Space>", "<Nop>", opts)

keymap("v", "p", '"_dP', opts)

-- Text editing
-- Faster movement to end and beggining of the line
keymap("n", "I", "$", opts)
keymap("n", "H", "^", opts)
keymap("v", "I", "$", opts)
keymap("v", "H", "^", opts)

-- <A-j> join line below, weird coz of other remap
local An = fn.has("macunix") == 1 and "ń" or "<A-n>"
keymap("n", An, "J", opts)

keymap("", "N", "9j", opts)
keymap("", "E", "9k", opts)

keymap("", "n", "j", opts)
keymap("", "e", "k", opts)
keymap("", "j", "e", opts)
keymap("", "J", "E", opts)

keymap("n", "Y", "y$", opts)
-- change current word and allow to use . for changing next words
keymap("n", "c*", "*Ncgn", opts)

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-n>", "<C-w>j", opts)
keymap("n", "<C-e>", "<C-w>k", opts)
keymap("n", "<C-i>", "<C-w>l", opts)
keymap("i", "<C-h>", "<cmd>wincmd h<cr>", opts)
keymap("i", "<C-n>", "<cmd>wincmd j<cr>", opts)
keymap("i", "<C-e>", "<cmd>wincmd k<cr>", opts)
keymap("i", "<C-i>", "<cmd>wincmd l<cr>", opts)

-- Go back and forward defined in setup_listeners.lua
keymap("n", "<C-l>", "<C-o>", opts)
keymap("n", "<C-u>", "<C-i>", opts)

keymap("n", "``", "``zz", opts)

-- Stay in indent mode when formatting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("n", "<Backspace>", "<C-^>", opts)

keymap("n", "U", "<c-r>", opts)

-- alt-backspace to delete word backwards
keymap("i", "<A-Backspace>", "<ESC>lcb", opts)
keymap("n", "<A-Backspace>", "lcb<ESC>", opts)

keymap("n", "<leader>w", "<cmd>wall<CR>", opts)
keymap("n", "<leader>e", "<cmd>e<CR>", opts)
keymap(
  "n",
  "<leader>q",
  "<cmd>wall<CR><cmd>lua vim.defer_fn(function() vim.cmd('qall') end, 100)<CR>",
  opts
)
