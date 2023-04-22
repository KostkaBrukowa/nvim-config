local references_handler = require("dupa.definitions_or_references.references")
local definion_or_references = require("definition-or-references")

definion_or_references.setup({
  before_start_callback = require("dupa.my_jumplist").push_new_entry_to_jumplist,
  after_jump_callback = require("dupa.my_jumplist").push_new_entry_to_jumplist,
  on_references_result = references_handler.handle_references_response,
})
