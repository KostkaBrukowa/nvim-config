local telescope = safe_require("telescope")
local actions = safe_require("telescope.actions")
local actions_set = safe_require("telescope.actions.set")
local project_nvim = safe_require("project_nvim")

if not telescope or not project_nvim then
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
		path_display = { "shorten", "tail" },
		mappings = {
			i = {
				["<ESC>"] = actions.close,
				["<A-ESC>"] = function()
					vim.cmd("stopinsert")
				end,
				["<C-Tab>"] = actions.move_selection_previous,
				["<A-Tab>"] = actions.move_selection_previous,
				["<C-u>"] = function(options)
					actions.add_to_qflist(options)
					vim.cmd([[copen]])
				end,
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

project_nvim.setup({})

telescope.load_extension("fzf")
telescope.load_extension("projects")
