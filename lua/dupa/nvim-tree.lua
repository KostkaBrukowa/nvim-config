local nvim_tree = safe_require("nvim-tree")

if not nvim_tree then
	return
end

local nvim_tree_config = safe_require("nvim-tree.config")

if not nvim_tree_config then
	return
end

local telescope_utils = safe_require("utils.telescope-custom-pickers")
local gwidth = vim.api.nvim_list_uis()[1].width
local gheight = vim.api.nvim_list_uis()[1].height
local width = math.floor(gwidth * 0.6)
local height = math.floor(gheight * 0.95)

nvim_tree.setup({
	hijack_netrw = true,
	view = {
		hide_root_folder = true,
		width = 45,
		side = "right",
		preserve_window_proportions = true,
		float = {
			enable = true,
			open_win_config = {
				relative = "editor",
				width = width,
				height = height,
				row = math.floor((gheight - height) * 0.2),
				col = math.floor(gwidth * 0.2),
			},
		},
		mappings = {
			custom_only = false,
			list = {
				{ key = "<Right>", action = "edit" },
				{ key = "<Left>", action = "close_node" },
				{ key = "v", action = "vsplit" },
				{ key = "E", action = "" },
				{ key = "e", action = "" },
				{
					key = "<leader>ff",
					action = "Find in folder",
					action_cb = telescope_utils.find_in_focused_file,
				},
				{
					key = "<leader>fp",
					action = "Find file in folder",
					action_cb = telescope_utils.find_file_in_focused_file,
				},
				{
					key = "<ESC>",
					action = "lose_focus",
					action_cb = function()
						vim.cmd("wincmd h")
					end,
				},
			},
		},
	},
	ignore_ft_on_setup = {
		"startify",
		"dashboard",
		"alpha",
	},
	filters = {
		custom = { "\\.git" },
		exclude = { ".gitignore", "scenarios.private.js" },
	},
	renderer = {
		add_trailing = false,
		group_empty = false,
		highlight_git = false,
		highlight_opened_files = "none",
		root_folder_modifier = ":t",
		indent_markers = {
			enable = false,
			icons = {
				corner = "└ ",
				edge = "│ ",
				none = "  ",
			},
		},
		icons = {
			webdev_colors = true,
			git_placement = "before",
			padding = " ",
			symlink_arrow = " ➛ ",
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
			},
			glyphs = {
				default = "",
				symlink = "",
				folder = {
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					untracked = "U",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
	update_focused_file = {
		enable = true,
		update_root = false,
	},
	sync_root_with_cwd = true,
	respect_buf_cwd = true,
})
