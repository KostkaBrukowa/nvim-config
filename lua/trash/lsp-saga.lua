local keymap = vim.keymap.set
local saga = require("lspsaga")

saga.init_lsp_saga()

local ASquareRight = vim.fn.has("macunix") == 1 and "≥" or "<A->>"
-- Lsp finder find the symbol definition implement reference
-- if there is no implement it will hide
-- when you use action in finder like open vsplit then you can
-- use <C-t> to jump back
keymap("n", ASquareRight, "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

-- Code action
keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })

-- Rename
keymap("n", "<leader>2", "<cmd>Lspsaga rename<CR>", { silent = true })

-- Peek Definition
-- you can edit the definition file in this flaotwindow
-- also support open/vsplit/etc operation check definition_action_keys
-- support tagstack C-t jump back
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })

-- Show line diagnostics
keymap("n", "gh", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })

-- Show cursor diagnostic

-- Diagnsotic jump can use `<c-o>` to jump back
keymap("n", "<C-n>", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })

-- Hover Doc
keymap("n", "gk", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
