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

-- Last buffers
--[[ keymap( ]]
--[[ 	"n", ]]
--[[ 	"<C-Tab>", ]]
--[[ 	"<cmd>lua require('telescope.builtin').buffers({sort_lastused = true, ignore_current_buffer = true})<CR>", ]]
--[[ 	opts ]]
--[[ ) ]]
keymap("n", "<C-Tab>", "<cmd>lua require('telescope.builtin').oldfiles()<CR>", opts)

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

-- TODO
-- let g:argtextobj_pairs="(:),{:},<:>,[:]"

keymap("n", "Y", "y$", opts)

-- make enter below and go back to original position
keymap("n", "<Enter>", "o<ESC>k", opts)
keymap("n", "<S-Enter>", "O<ESC>j", opts)

-- change current word and allow to use . for changing next words
keymap("n", "c*", "*Ncgn", opts)

-- Git commands TODO
-- nmap :gpl <Action>(Git.Pull)

-- leader mappings
-- TODO
-- nmap <leader>c <Action>(Vcs.Show.Local.Changes)

keymap("n", "<leader>r", "<Plug>ReplaceWithRegisterOperator", {})
keymap("n", "<leader>rr", "<Plug>ReplaceWithRegisterLine", {})

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-n>", "<C-w>j", opts)
keymap("n", "<C-e>", "<C-w>k", opts)
keymap("n", "<C-i>", "<C-w>l", opts)

-- Go back and forward
keymap("n", "<C-l>", "<C-o>", opts)
keymap("n", "<C-u>", "<C-i>", opts)

keymap("n", "``", "``zz", opts)

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
    autocmd VimEnter * silent! stopinsert
  augroup end
]])

-- Remove cursor from inactive windows disables cursor in nvim tree which is bad
--[[ vim.cmd([[ ]]
--[[   augroup CursorLineOnlyInActiveWindow ]]
--[[     autocmd! ]]
--[[     autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline ]]
--[[     autocmd WinLeave * setlocal nocursorline ]]
--[[   augroup END   ]]
--[[ \]\]) ]]

-- nnoremap <M-n> <C-u>
-- nnoremap <C-i> ea

-- NOT MINE
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
