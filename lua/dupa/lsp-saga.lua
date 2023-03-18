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

-- Code action
vim.keymap.set({ "n", "v" }, "<C-.>", vim.lsp.buf.code_action, { silent = true })
-- Rename
vim.keymap.set("n", "<leader>2", vim.lsp.buf.rename, { silent = true })
keymap("n", "gt", "<cmd>lua vim.lsp.buf.hover()<CR>", { silent = true })
keymap("i", "<c-i>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { silent = true })

-- Peek Definition
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
-- Show line diagnostics
keymap("n", "gh", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
-- Diagnsotic jump can use `<c-o>` to jump back
keymap("n", "<C-k>", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
