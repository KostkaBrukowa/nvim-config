local tint = safe_require("tint")

if not tint then
	return
end

tint.setup({
	window_ignore_function = function(winid)
		local bufid = vim.api.nvim_win_get_buf(winid)
		local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
		local isFloating = vim.api.nvim_win_get_config(winid).relative ~= ""
		local ignoredFiletypes = { "DiffviewFiles", "DiffviewFileHistory" }
		local ignoredBuftypes = {}
		local isDiff = vim.api.nvim_win_get_option(winid, "diff")

		--[[ local currentBuffer = string.lower(vim.api.nvim_buf_get_name(bufid)) ]]
		--[[ local is_diffview_focused = string.find(currentBuffer, "diffview") ~= nil ]]
		local isIgnoredBuftype = vim.tbl_contains(ignoredBuftypes, vim.api.nvim_buf_get_option(bufid, "buftype"))
		local isIgnoredFiletype = vim.tbl_contains(ignoredFiletypes, vim.api.nvim_buf_get_option(bufid, "filetype"))

		if isDiff then
			require("tint").untint(winid)
		end

		return isDiff or isFloating or isIgnoredBuftype or isIgnoredFiletype
	end,
})
