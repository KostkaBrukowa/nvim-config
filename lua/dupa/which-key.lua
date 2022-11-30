local which_key = safe_require("which-key")
local legendary = safe_require("legendary")

if not which_key or not legendary then
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
	["q"] = { "<cmd>wall<CR><cmd>qall<CR>", "Save and Quit" },
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
	["f"] = {
		name = "Find",
		["f"] = { "<cmd>lua require('telescope.builtin').live_grep()<CR>", "Live grep" },
		["l"] = { "<cmd>lua require('telescope.builtin').resume()<CR>", "Last find window" },
		["L"] = {
			"<cmd>lua require('utils.telescope-custom-pickers').last_picker()<CR>",
			"Last find window with index",
		},
		["s"] = { "<cmd>lua require('telescope.builtin').grep_string()<CR>", "Grep string" },
		["p"] = { "<cmd>lua require('telescope.builtin').find_files()<CR>", "Files" },
		["h"] = { "<cmd>lua require('telescope.builtin').help_tags()<CR>", "Help tags" },
		["b"] = { "<cmd>lua require('telescope.builtin').buffers()<CR>", "Buffers" },
		["o"] = { "<cmd>lua require('utils.telescope-custom-pickers').open_saved_project_picker()<CR>", "Projects" },
		["c"] = { "<cmd>Legendary<CR>", "All commands" },
		["t"] = { "<cmd>lua require('other-nvim').open('test')<CR>", "Find test file" },
	},
	["g"] = {
		name = "Git",
		["s"] = { "<cmd>lua require('telescope.builtin').git_status()<CR>", "Status" },
		["c"] = { "<cmd>Git commit<CR>", "Commit files" },
		["n"] = { "<cmd>Git commit --amend<CR>", "Commit ammend" },
		["a"] = { "<cmd>Git add .<CR>", "Add everything" },
		["b"] = { "<cmd>lua require('utils.telescope-custom-pickers').checkout_remote_smart()<CR>", "Branches" },
		["m"] = { "<cmd>lua require('utils.telescope-custom-pickers').merge_branch()<CR>", "Git merge" },
		["p"] = { "<cmd>Git push<CR>", "Git push" },
		["l"] = { "<cmd>Git pull<CR>", "Git pull" },
		["g"] = { "<cmd>Git<CR>", "Fugitive" },
		["u"] = { "<cmd>lua require('gitlinker').get_buf_range_url('n')<CR>", "Get github url/link" },
		["f"] = { "<cmd>DiffviewFileHistory %<CR>", "File history" },
	},
	["d"] = {
		name = "Diff View",
		["o"] = { "<cmd>DiffviewOpen<CR>", "Open" },
		["c"] = { "<cmd>DiffviewClose<CR>", "Close" },
		["d"] = { "<cmd>diffoff<CR>", "Close fugitive diff" },
		["p"] = { "<cmd>Gitsigns preview_hunk<CR>", "Preview hunk" },
		["r"] = { "<cmd>Gitsigns reset_hunk<CR>", "Reset hunk" },
	},
	["u"] = {
		name = "Utils",
		["p"] = { "<cmd>Glow<CR>", "Preview Markdown" },
		["z"] = { "<cmd>TZAtaraxis<CR>", "Zen mode" },
		["c"] = { "<cmd>%bd|e#<CR><CR>", "Close all buffers except active" },
		["m"] = { "<cmd>WindowsMaximize<cr>", "Maximize current buffer" },
		["t"] = {
			"<cmd>lua require('utils.treesitter-utils').goto_translation()<CR>",
			"Close all buffers except active",
		},
	},
	["i"] = {
		name = "Imports",
		["a"] = { "<cmd>TypescriptAddMissingImports<CR>", "Add missing imports" },
		["o"] = { "<cmd>TypescriptOrganizeImports<CR>", "Organize imports" },
		["u"] = { "<cmd>TypescriptRemoveUnused<CR>", "Remove unused" },
	},
	["h"] = {
		name = "Harpoon",
		["m"] = { "<cmd>lua require('harpoon.mark').toggle_file()<CR>", "Add mark" },
		["q"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", "Quick menu" },
		["a"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", "Nav file 1" },
		["r"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", "Nav file 2" },
		["s"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", "Nav file 3" },
		["t"] = { "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", "Nav file 4" },
		["h"] = { "<cmd>lua require('harpoon.ui').nav_prev()<CR>", "Mark prev" },
		["i"] = { "<cmd>lua require('harpoon.ui').nav_next()<CR>", "Mark next" },
	},
	["n"] = {
		["name"] = "Neotest",
		["a"] = { "<cmd>lua require('neotest').run.attach()<cr>", "Attach" },
		["f"] = { "<cmd>w<cr><cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Run File" },
		["F"] = {
			"<cmd>w<cr><cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
			"Debug File",
		},
		["l"] = { "<cmd>w<cr><cmd>lua require('neotest').run.run_last()<cr>", "Run Last" },
		["L"] = { "<cmd>w<cr><cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<cr>", "Debug Last" },
		["n"] = { "<cmd>w<cr><cmd>lua require('neotest').run.run()<cr>", "Run Nearest" },
		["N"] = { "<cmd>w<cr><cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Debug Nearest" },
		["O"] = { "<cmd>lua require('neotest').output.open({ enter = true })<cr>", "Full Output" },
		["o"] = { "<cmd>lua require('neotest').output.open({ enter = true, short = true })<cr>", "Short output" },
		["S"] = { "<cmd>lua require('neotest').run.stop()<cr>", "Stop" },
		["s"] = { "<cmd>lua require('neotest').summary.open()<cr>", "Summary" },
	},
}

local visual_opts = {
	mode = "v",
	prefix = "<leader>",
	silent = true,
	noremap = true,
}

local visual_mappings = {
	["y"] = { '"+y', "Yank to global register" },
	["r"] = {
		name = "Find and replace",
		["o"] = { "<esc>:lua require('spectre').open_visual()<cr>", "Find under cursor" },
	},
	["g"] = {
		name = "Git",
		["u"] = { "<cmd>lua require('gitlinker').get_buf_range_url('v')<CR>", "Fugitive" },
	},
}

legendary.setup({ which_key = { auto_register = true } })
which_key.setup(setup)

which_key.register(mappings, opts)
which_key.register(visual_mappings, visual_opts)
