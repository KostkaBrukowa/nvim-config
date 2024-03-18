-- local copilot = require("copilot")
-- local copilot_suggestion = require("copilot.suggestion")
--
-- copilot.setup({
--   suggestion = {
--     enabled = true,
--     auto_trigger = true,
--     debounce = 500,
--     keymap = {
--       accept = nil,
--       accept_word = false,
--       accept_line = false,
--       next = nil,
--       prev = nil,
--       dismiss = "<C-]>",
--     },
--   },
-- })
--
-- local keymap_amend = require("keymap-amend")
--
-- keymap_amend("i", "<Right>", function(original)
--   if copilot_suggestion.is_visible() then
--     copilot_suggestion.accept()
--   else
--     original()
--   end
-- end)
--
-- keymap_amend("i", "<C-,>", function(original)
--   if copilot_suggestion.is_visible() then
--     copilot_suggestion.next()
--   else
--     original()
--   end
-- end)

vim.keymap.set("i", "<Right>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true
vim.keymap.set("i", "<C-l>", "<Plug>(copilot-next)")
vim.keymap.set("i", "<C-u>", "<Plug>(copilot-previous)")
vim.keymap.set("i", "<C-y>", "<Plug>(copilot-suggest)")

