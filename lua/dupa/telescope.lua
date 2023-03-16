local telescope = safe_require("telescope")
local actions = safe_require("telescope.actions")
local actions_set = safe_require("telescope.actions.set")

if not telescope then
	return
end

if not actions then
	return
end

if not actions_set then
	return
end

telescope.setup({
	defaults = {
		cache_picker = {
			num_pickers = 3,
		},
		file_ignore_patterns = {
			".git/",
			"node_modules/*",
		},
		path_display = { ["shorten"] = 3 },
		mappings = {
			i = {
				["<ESC>"] = actions.close,
				["<A-ESC>"] = function()
					vim.cmd("stopinsert")
				end,
				["<C-Tab>"] = actions.move_selection_previous,
				["<A-Tab>"] = actions.move_selection_previous,
				["<C-e>"] = actions.preview_scrolling_up,
				["<C-n>"] = actions.preview_scrolling_down,
			},
			n = {
				["e"] = actions.move_selection_previous,
				["n"] = actions.move_selection_next,
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("project")
telescope.load_extension("refactoring")
