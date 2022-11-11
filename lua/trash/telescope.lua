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
		--[[ get_selection_window = function(picker, entry) ]]
		--[[ 	print(vim.inspect(picker)) ]]
		--[[ 	return 0 ]]
		--[[ end, ]]
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
				["<C-u>"] = function(options)
					actions.add_to_qflist(options)
					vim.cmd([[copen]])
				end,
				--[[ ["<Cr>"] = function(bufnr) ]]
				--[[ 	actions_set.edit(bufnr, "tab drop") ]]
				--[[ end, ]]
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = false,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("project")
