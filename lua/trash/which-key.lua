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
	["x"] = { "<cmd>q<CR>", "Close buffer" },
	["p"] = { "<cmd>lua vim.lsp.buf.format({ timeout_ms = 60000})<CR>", "Format with prettier" },
	["s"] = { "<Plug>(leap-forward-to)", "Leap forward" },
	["S"] = { "<Plug>(leap-backward-to)", "Leap backwards" },
	["c"] = { "<cmd>DiffviewToggle<cr>", "Toggle diffview" },
	["r"] = {
		name = "Find and replace",
		["o"] = { "<cmd>lua require('spectre').open()<cr>", "Open" },
		["w"] = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Seach current word" },
		["l"] = { "<cmd>lua require('spectre').resume_last_search()<cr>", "Resume last search" },
		["f"] = { "<cmd>lua require('spectre').open_file_search()<cr>", "Rearch in file" },
	},
	["t"] = {
		name = "File Explorer",
		["t"] = { "<cmd>NvimTreeToggle<CR>", "Toggle" },
		["f"] = { "<cmd>NvimTreeRefresh<CR>", "Refresh" },
		["c"] = { "<cmd>NvimTreeClose<CR>", "Close" },
		["o"] = { "<cmd>NvimTreeCollapse<CR>", "Collapse" },
		["r"] = { "<cmd>TypescriptRenameFile<CR>", "Rename file" },
	},
	["h"] = {
		name = "Hunks",
		["p"] = { "<cmd>Gitsigns preview_hunk<CR>", "Preview" },
		["r"] = { "<cmd>Gitsigns reset_hunk<CR>", "Reset" },
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
		["l"] = { "<cmd>lua require('telescope.builtin').resume()<CR>", "Last find window" },
		["s"] = { "<cmd>lua require('telescope.builtin').grep_string()<CR>", "Grep string" },
		["p"] = { "<cmd>lua require('telescope.builtin').find_files()<CR>", "Files" },
		["h"] = { "<cmd>lua require('telescope.builtin').help_tags()<CR>", "Help tags" },
		["b"] = { "<cmd>lua require('telescope.builtin').buffers()<CR>", "Buffers" },
		["o"] = { "<cmd>lua require('telescope').extensions.project.project({})<CR>", "Projects" },
	},
	["g"] = {
		name = "Git",
		["s"] = { "<cmd>lua require('telescope.builtin').git_status()<CR>", "Status" },
		["c"] = { "<cmd>Git commit<CR>", "Commit files" },
		["m"] = { "<cmd>Git commit --amend<CR>", "Commit ammend" },
		["a"] = { "<cmd>Git add .<CR>", "Add everything" },
		["b"] = { "<cmd>lua require('telescope.builtin').git_branches()<CR>", "Branches" },
		["p"] = { "<cmd>Git push<CR>", "Git push" },
		["l"] = { "<cmd>Git pull<CR>", "Git pull" },
		["g"] = { "<cmd>Git<CR>", "Fugitive" },
		["u"] = { "<cmd>lua require('gitlinker').get_buf_range_url('n')<CR>", "Fugitive" },
	},
	["d"] = {
		name = "Diff View",
		["o"] = { "<cmd>DiffviewOpen<CR>", "Open" },
		["c"] = { "<cmd>DiffviewClose<CR>", "Close" },
		["f"] = { "<cmd>DiffviewFileHistory %<CR>", "File history" },
	},
	["u"] = {
		name = "Utils",
		["m"] = { "<cmd>Glow<CR>", "Preview Markdown" },
		["z"] = { "<cmd>TZAtaraxis<CR>", "Zen mode" },
		["c"] = { "<cmd>highlight Cursor<CR>", "Get color under curor" },
	},
	["i"] = {
		name = "Imports",
		["a"] = { "<cmd>TypescriptAddMissingImports<CR>", "Add missing imports" },
		["o"] = { "<cmd>TypescriptOrganizeImports<CR>", "Organize imports" },
		["u"] = { "<cmd>TypescriptRemoveUnused<CR>", "Remove unused" },
	},
}

local visual_opts = {
	mode = "v",
	prefix = "<leader>",
	silent = true,
	noremap = true,
}

local visual_mappings = {
	["r"] = {
		name = "Find and replace",
		["o"] = { "<esc>:lua require('spectre').open_visual()<cr>", "Find under cursor" },
	},
	["g"] = {
		name = "Git",
		["u"] = { "<cmd>lua require('gitlinker').get_buf_range_url('v')<CR>", "Fugitive" },
	},
}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(visual_mappings, visual_opts)
