local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
local fn = vim.fn

-- Leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("v", "p", '"_dP', opts)

-- Tree
keymap("n", "<C-1>", "<cmd>lua require('utils.tree').focusOrToggleIfFocused()<CR>", opts)

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
keymap("", "k", "n", opts)
keymap("", "K", "N", opts)

keymap("n", "Y", "y$", opts)

-- make enter below and go back to original position
keymap("n", "<Enter>", "o<ESC>k", opts)
keymap("n", "<S-Enter>", "O<ESC>j", opts)

-- change current word and allow to use . for changing next words
keymap("n", "c*", "*Ncgn", opts)

-- Plugins
keymap("n", "<leader>r", "<cmd>lua require('substitute').operator()<cr>", opts)
keymap("n", "<leader>rr", "<cmd>lua require('substitute').line()<cr>", opts)

keymap("v", "*", "<Plug>(visualstar-*)", opts)

-- Old files
keymap("n", "<C-Tab>", "<cmd>lua require('telescope.builtin').oldfiles()<CR>", opts)
keymap("n", "<A-Tab>", "<cmd>lua require('telescope.builtin').oldfiles()<CR>", opts)

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-n>", "<C-w>j", opts)
keymap("n", "<C-e>", "<C-w>k", opts)
keymap("n", "<C-i>", "<C-w>l", opts)

-- Go back and forward
keymap("n", "<C-l>", "<C-o>", opts)
keymap("n", "<C-u>", "<C-i>", opts)

keymap("n", "``", "``zz", opts)

-- mapping to execute in spectre as vim.normal
keymap("n", "|||", "<c-w><c-p>", opts)

-- Stay in indent mode when formatting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Highlight on yank
vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank { timeout = 300 }
  augroup end
]])
--
-- Enter normal mode on init
vim.cmd([[
  augroup NormalModeInit
    autocmd!
    autocmd BufEnter * silent! stopinsert
  augroup end
]])

-- Enter normal mode on init
-- vim.cmd([[
--   augroup Test
--     autocmd!
--     autocmd BufWritePost,FileWritePost * :lua print('Saved')
--   augroup end
-- ]])
