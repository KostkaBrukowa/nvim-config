local keymap = vim.keymap.set
local saga = require("lspsaga")

saga.setup({
	--[[ show_diagnostic_source = true, ]]
	ui = {
		theme = "round",
		border = "rounded",
		colors = {
			--float window normal background color
			normal_bg = "#1d1536",
			--title background color
			title_bg = "#afd700",
			red = "#e95678",
			magenta = "#b33076",
			orange = "#FF8700",
			yellow = "#f7bb3b",
			green = "#afd700",
			cyan = "#36d0e0",
			blue = "#61afef",
			purple = "#CBA6F7",
			white = "#d1d4cf",
			black = "#1c1c19",
		},
	},
	finder = {
		quit = { "q", "<ESC>" },
	},
	diagnostic = {
		show_source = true,
		keys = {
			quit = "esc",
		},
	},
	request_timeout = 5000,
	preview = {
		lines_above = 3,
	},
	code_action = {
		keys = {
			quit = "<esc>",
			exec = "<CR>",
		},
	},
	lightbulb = {
		enable = false,
	},
})

local ASquareRight = vim.fn.has("macunix") == 1 and "≥" or "<A->>"
-- Lsp finder find the symbol definition implement reference
-- if there is no implement it will hide
-- when you use action in finder like open vsplit then you can
-- use <C-t> to jump back
-- keymap("n", "<leader><leader>s", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
-- keymap("n", ASquareRight, "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

-- Code action
keymap({ "n", "v" }, "<C-.>", "<cmd>Lspsaga code_action<CR>", { silent = true })

-- Rename
keymap("n", "<leader>2", "<cmd>lua vim.lsp.buf.rename()<CR>", { silent = true })

-- Peek Definition
-- you can edit the definition file in this flaotwindow
-- also support open/vsplit/etc operation check definition_action_keys
-- support tagstack C-t jump back
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })

-- Show line diagnostics
keymap("n", "gh", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })

-- Show cursor diagnostic

-- Diagnsotic jump can use `<c-o>` to jump back
keymap("n", "<C-k>", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })

-- Hover Doc
keymap("n", "gt", "<cmd>lua vim.lsp.buf.hover()<CR>", { silent = true })
keymap("i", "<c-i>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { silent = true })
-- keymap("n", "gt", "<cmd>lua require('noice.lsp').hover()<CR>", { silent = true })
