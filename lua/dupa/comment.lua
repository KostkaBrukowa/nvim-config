local comment = safe_require("Comment")
local comment_utils = safe_require("Comment.utils")
local commentstring_utils = safe_require("ts_context_commentstring.utils")
local commentstring_internal = safe_require("ts_context_commentstring.internal")

if not comment then
	return
end

if not comment_utils then
	return
end

if not commentstring_utils then
	return
end

if not commentstring_internal then
	return
end

comment.setup({
	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})

vim.keymap.set("n", "<leader>/", function()
	return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)j" or "<Plug>(comment_toggle_linewise_count)"
end, { expr = true })

vim.keymap.set("v", "<leader>/", function()
	return "<Plug>(comment_toggle_linewise_visual)"
end, { expr = true })
