local references_handler = require("dupa.definitions_or_references.references")
local definion_or_references = require("definition-or-references")

definion_or_references.setup({
  on_references_result = references_handler.handle_references_response,
})
