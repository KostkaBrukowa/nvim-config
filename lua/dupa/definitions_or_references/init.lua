local references_handler = require("dupa.definitions_or_references.references")
local definition_or_references = require("definition-or-references")

definition_or_references.setup({
  debug = false,
  on_references_result = references_handler.handle_references_response,
})

vim.keymap.set("n", "<LeftMouse>", function() end)
