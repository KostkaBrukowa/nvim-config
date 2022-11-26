local keymap = vim.keymap.set
local saga = require("lspsaga")

saga.init_lsp_saga({
	--[[ show_diagnostic_source = true, ]]
	finder_request_timeout = 5000,
	move_in_saga = { prev = "e", next = "n" },
	preview_lines_above = 3,
	code_action_keys = {
		quit = "<esc>",
		exec = "<CR>",
	},
	code_action_lightbulb = {
		enable = true,
		enable_in_insert = true,
		cache_code_action = true,
		sign = false,
		update_time = 150,
		sign_priority = 20,
		virtual_text = true,
	},
	-- TODO
	--[[ symbol_in_winbar = { ]]
	--[[ 	in_custom = true, ]]
	--[[ }, ]]
})

local ASquareRight = vim.fn.has("macunix") == 1 and "≥" or "<A->>"
-- Lsp finder find the symbol definition implement reference
-- if there is no implement it will hide
-- when you use action in finder like open vsplit then you can
-- use <C-t> to jump back
-- keymap("n", "<leader><leader>s", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
keymap(
	"n",
	ASquareRight,
	"<cmd>lua require('modified-plugins.lspsaga.lua.lspsaga.finder'):lsp_finder()<CR>",
	{ silent = true }
)

-- Code action
keymap({ "n", "v" }, "<C-.>", "<cmd>Lspsaga code_action<CR>", { silent = true })

-- Rename
keymap("n", "<leader>2", "<cmd>Lspsaga rename<CR>", { silent = true })

-- Peek Definition
-- you can edit the definition file in this flaotwindow
-- also support open/vsplit/etc operation check definition_action_keys
-- support tagstack C-t jump back
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })

-- Show line diagnostics
keymap(
	"n",
	"gh",
	"<cmd>lua require('modified-plugins.lspsaga.lua.lspsaga.diagnostic'):show_line_diagnostics()<CR>",
	{ silent = true }
)

-- Show cursor diagnostic

-- Diagnsotic jump can use `<c-o>` to jump back
--[[ keymap("n", "<C-k>", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true }) ]]
keymap(
	"n",
	"<C-k>",
	"<cmd>lua require('modified-plugins.lspsaga.lua.lspsaga.diagnostic'):goto_next()<CR>",
	{ silent = true }
)

-- Hover Doc
keymap("n", "gt", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
