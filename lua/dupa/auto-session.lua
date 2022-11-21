local session = require("auto-session")
if not session then
	return
end

session.setup({
	log_level = "error",
	auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
	pre_save_cmds = { 'lua require("dupa.auto-session").close_plugin_owned()' },
})

local M = {}
M.close_plugin_owned = function()
	-- Jump to preview window if current window is plugin owned.
	if M.is_plugin_owned(0) then
		vim.cmd([[ wincmd p ]])
	end

	for _, win in ipairs(vim.fn.getwininfo()) do
		if M.is_plugin_owned(win.bufnr) then
			-- Delete plugin owned window buffers.
			vim.api.nvim_buf_delete(win.bufnr, {})
		end
	end
end

-- Detect if window is owned by plugin by checking buftype.
M.is_plugin_owned = function(bufid)
	local origin_type = vim.api.nvim_buf_get_option(bufid, "buftype")
	local name = vim.api.nvim_buf_get_name(bufid)

	if origin_type == "" or origin_type == "help" then
		return false
	end

	return true
end

return M
