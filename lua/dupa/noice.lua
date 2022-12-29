local function filter_entry(find)
	return {
		filter = { event = "msg_show", kind = "", find = find },
		opts = { skip = true },
	}
end

local routes = {
	filter_entry("written"),
	filter_entry("lines yanked"),
	filter_entry("%d change; before"),
	filter_entry("%d change; after"),
	filter_entry("%d more lines"),
	filter_entry("%d more line"),
	filter_entry("%d line less"),
	filter_entry("%d fewer lines"),
	filter_entry("%d change; before"),
}

require("noice").setup({
	cmdline = {
		enabled = true, -- enables the Noice cmdline UI
	},
	messages = {
		-- NOTE: If you enable messages, then the cmdline is enabled automatically.
		-- This is a current Neovim limitation.
		enabled = true, -- enables the Noice messages UI
	},
	routes = routes,
	popupmenu = {
		enabled = true, -- enables the Noice popupmenu UI
	},
	notify = {
		enabled = true,
	},
	lsp = {
		progress = {
			enabled = true,
		},
		hover = {
			enabled = true,
		},
		signature = {
			enabled = true,
		},
	},
	presets = {
		-- you can enable a preset by setting it to true, or a table that will override the preset config
		-- you can also add custom presets that you can enable/disable with enabled=true
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = false, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = true, -- add a border to hover docs and signature help
	},
})
