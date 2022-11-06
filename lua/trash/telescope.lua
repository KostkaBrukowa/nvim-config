local telescope = safe_require("telescope")
local actions = safe_require("telescope.actions")

if not telescope then
	return
end

if not actions then
	return
end

telescope.setup({
	defaults = {
		file_ignore_patterns = {
			".git/",
			"node_modules/*",
		},
		mappings = {
			i = {
				["<ESC>"] = actions.close,
				["<C-Tab>"] = actions.move_selection_previous,
			},
		},
	},
})
