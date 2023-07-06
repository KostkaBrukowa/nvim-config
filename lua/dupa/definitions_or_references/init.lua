local references_handler = require("dupa.definitions_or_references.references")
local definition_or_references = require("definition-or-references")

definition_or_references.setup({
  debug = false,
  on_references_result = references_handler.handle_references_response,
})

local function move_mouse_and_definition_or_references()
  -- Simulate click to place cursor on correct position
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<LeftMouse>", false, false, true),
    "in",
    false
  )

  -- defer to let nvim refresh to get correct position
  vim.defer_fn(function()
    require("definition-or-references").definition_or_references()
  end, 0)
end

vim.keymap.set("n", "<LeftMouse>", function() end)
vim.keymap.set("n", "<2-LeftMouse>", function() end)
vim.keymap.set("n", "<3-LeftMouse>", function() end)
vim.keymap.set("n", "<4-LeftMouse>", function() end)

vim.keymap.set("n", "<C-LeftMouse>", move_mouse_and_definition_or_references)
vim.keymap.set("n", "<2-LeftMouse>", move_mouse_and_definition_or_references)
