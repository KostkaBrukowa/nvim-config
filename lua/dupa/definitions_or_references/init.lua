local definitions = require("dupa.definitions_or_references.definitions")
local references = require("dupa.definitions_or_references.references")

local function definition_or_references()
	require("dupa.my_jumplist").push_new_entry_to_jumplist()
	references.send_references_request()
	definitions()
end

vim.api.nvim_set_keymap(
	"n",
	vim.fn.has("macunix") == 1 and "≥" or "<A->>",
	"<cmd>lua require('dupa.definitions_or_references').definitions_or_references()<CR>",
	{ silent = true }
)

return {
	definitions_or_references = definition_or_references,
}
