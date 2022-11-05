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

-- TODO
-- let g:argtextobj_pairs="(:),{:},<:>,[:]"

keymap("n", "Y", "y$", opts)

-- make enter below and go back to original position
keymap("n", "<Enter>", "o<ESC>k", opts)
keymap("n", "<S-Enter>", "O<ESC>j", opts)

-- change current word and allow to use . for changing next words
keymap("n", "c*", "*Ncgn", opts)

-- Git commands TODO
-- nmap :gb <Action>(Git.Branches)
-- nmap :gpl <Action>(Git.Pull)

-- leader mappings

-- TODO
-- nmap <leader>f <Action>(OptimizeImports)<Action>(Javascript.Linters.EsLint.Fix)
-- nmap <leader>p <Action>(ReformatWithPrettierAction)
-- nmap <leader>c <Action>(Vcs.Show.Local.Changes)

keymap("n", "<leader>r", "<Plug>ReplaceWithRegisterOperator", {})
keymap("n", "<leader>rr", "<Plug>ReplaceWithRegisterLine", {})

-- TODO
-- nmap gh <Action>(ShowErrorDescription)

keymap("n", "``", "``zz", opts)

-- Highlight on yank
vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank { timeout = 300 }
  augroup end
]])

-- nnoremap <M-n> <C-u>
-- nnoremap <C-i> ea

-- NOT MINE
-- Window navigation
--[[ keymap("n", "<C-h>", "<C-w>h", opts) ]]
--[[ keymap("n", "<C-j>", "<C-w>j", opts) ]]
--[[ keymap("n", "<C-k>", "<C-w>k", opts) ]]
--[[ keymap("n", "<C-l>", "<C-w>l", opts) ]]
--[[ keymap("n", "<leader>h", "<C-w>h", opts) ]]
--[[ keymap("n", "<leader>j", "<C-w>j", opts) ]]
--[[ keymap("n", "<leader>k", "<C-w>k", opts) ]]
--[[ keymap("n", "<leader>l", "<C-w>l", opts) ]]
--hj

-- Resize
--[[ keymap("n", "<M-j>", ":resize -2<CR>", opts) ]]
--[[ keymap("n", "<M-k>", ":resize +2<CR>", opts) ]]
--[[ keymap("n", "<M-l>", ":vertical resize -2<CR>", opts) ]]
--[[ keymap("n", "<M-h>", ":vertical resize +2<CR>", opts) ]]

-- Navigate buffers
--[[ keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", opts) ]]
--[[ keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", opts) ]]

-- Stay in indent mode
--[[ keymap("v", "<", "<gv", opts) ]]
--[[ keymap("v", ">", ">gv", opts) ]]

-- Move text up and down
--[[ keymap("v", "<A-j>", ":m .+1<CR>==", opts) ]]
--[[ keymap("v", "<A-k>", ":m .-2<CR>==", opts) ]]
--[[ keymap("x", "J", ":move '>+1<CR>gv-gv", opts) ]]
--[[ keymap("x", "K", ":move '<-2<CR>gv-gv", opts) ]]
--[[ keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts) ]]
--[[ keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts) ]]
