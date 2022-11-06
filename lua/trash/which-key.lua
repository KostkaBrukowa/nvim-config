local which_key = safe_require("which-key")

if not which_key then
	return
end

local setup = {
	plugins = {
		marks = true,
		registers = true,
		spelling = {
			enabled = true,
			suggestions = 20,
		},
		presets = {
			operators = false,
			motions = false,
			text_objects = false,
			windows = false,
			nav = false,
			z = true,
			g = true,
		},
	},
	window = {
		border = "rounded",
		position = "bottom",
		margin = { 1, 0, 1, 0 },
		padding = { 2, 2, 2, 2 },
		winblend = 0,
	},
	ignore_missing = true,
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
	show_help = false,
	triggers = "auto",
}

local opts = {
	mode = "n",
	prefix = "<leader>",
	silent = true,
	noremap = true,
}

local mappings = {
	["w"] = { "<cmd>wall<CR>", "Save" },
	["q"] = { "<cmd>qall<CR>", "Quit" },
	["x"] = { "<cmd>bd<CR>", "Close buffer" },
	["p"] = { "<cmd>lua vim.lsp.buf.format({ timeout_ms = 60000})<CR>", "Format with prettier" },
	["s"] = { "<Plug>(leap-forward-to)", "Leap" },
	["t"] = {
		name = "File Explorer",
		["t"] = { "<cmd>NvimTreeToggle<CR>", "Toggle" },
		["f"] = { "<cmd>NvimTreeRefresh<CR>", "Refresh" },
		["c"] = { "<cmd>NvimTreeClose<CR>", "Close" },
		["o"] = { "<cmd>NvimTreeCollapse<CR>", "Collapse" },
		["r"] = { "<cmd>TypescriptRenameFile<CR>", "Rename file" },
	},
	["b"] = {
		name = "Buffers",
		["b"] = { "<cmd>lua require('telescope.builtin').buffers()<CR>", "Buffers search" },
		["l"] = { "<cmd>BufferLineCloseRight<CR>", "Close all to right" },
		["h"] = { "<cmd>BufferLineCloseLeft<CR>", "Close all to left" },
		["d"] = { "<cmd>lua require('bufdelete').bufdelete(0, true)<CR>", "Close Current" },
		["m"] = { "<cmd>BufferLineCloseRight<CR><cmd>BufferLineCloseLeft<CR>", "Close except active" },
	},
	["f"] = {
		name = "Find",
		["f"] = { "<cmd>lua require('telescope.builtin').live_grep()<CR>", "Live grep" },
		["s"] = { "<cmd>lua require('telescope.builtin').grep_string()<CR>", "Grep string" },
		["p"] = { "<cmd>lua require('telescope.builtin').find_files()<CR>", "Files" },
		["h"] = { "<cmd>lua require('telescope.builtin').help_tags()<CR>", "Help tags" },
		["b"] = { "<cmd>lua require('telescope.builtin').buffers()<CR>", "Buffers" },
	},
	["g"] = {
		name = "Git",
		["s"] = { "<cmd>lua require('telescope.builtin').git_status()<CR>", "Status" },
		["c"] = { "<cmd>lua require('telescope.builtin').git_commits()<CR>", "Commits" },
		["b"] = { "<cmd>lua require('telescope.builtin').git_branches()<CR>", "Branches" },
		["p"] = { "<cmd>Git pull<CR>", "Git pull" },
		["g"] = { "<cmd>Git<CR>", "Fugitive" },
		["r"] = { "<cmd>Gread<CR>", "Checkout file" },
	},
	["d"] = {
		name = "Diff View",
		["o"] = { "<cmd>DiffviewOpen<CR>", "Open" },
		["c"] = { "<cmd>DiffviewClose<CR>", "Close" },
	},
	["u"] = {
		name = "Utils",
		["m"] = { "<cmd>Glow<CR>", "Preview Markdown" },
		["z"] = { "<cmd>TZAtaraxis<CR>", "Zen mode" },
	},
	["i"] = {
		name = "Imports",
		["a"] = { "<cmd>TypescriptAddMissingImports<CR>", "Add missing imports" },
		["o"] = { "<cmd>TypescriptOrganizeImports<CR>", "Organize imports" },
		["u"] = { "<cmd>TypescriptRemoveUnused<CR>", "Remove unused" },
	},
}

which_key.setup(setup)
which_key.register(mappings, opts)
