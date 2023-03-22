local definitions = require("dupa.definitions_or_references.definitions")
local references = require("dupa.definitions_or_references.references")

local function definition_or_references()
	require("dupa.my_jumplist").push_new_entry_to_jumplist()
	references.send_references_request()
	definitions()
end

return {
	definitions_or_references = definition_or_references,
}
