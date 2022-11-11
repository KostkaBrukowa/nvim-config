local spectre = safe_require("spectre")
local spectre_actions = safe_require("spectre.actions")

if not spectre then
	return
end

spectre.setup({
	mapping = {
		["Preview"] = {
			map = "<Tab>",
			cmd = "<cmd>lua require('utils.spectre').preview_spectre_file()<CR>",
			desc = "test",
		},
	},
	highlight = {
		ui = "String",
		search = "SpectreReplace",
		replace = "Search",
	},
})
