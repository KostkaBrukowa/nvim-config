local M = {}

function M.current_cursor_not_on_result(result)
	local target_uri = result.targetUri or result.uri
	local target_range = result.targetRange or result.range

	local target_bufnr = vim.uri_to_bufnr(target_uri)
	local target_row_start = target_range.start.line + 1
	local target_row_end = target_range["end"].line + 1
	local target_col_start = target_range.start.character + 1
	local target_col_end = target_range["end"].character + 1

	local current_bufnr = vim.fn.bufnr("%")
	local current_range = vim.api.nvim_win_get_cursor(0)
	local current_row = current_range[1]
	local current_col = current_range[2] + 1 -- +1 because if cursor highlights first character its a column behind

	return target_bufnr ~= current_bufnr
		or current_row < target_row_start
		or current_row > target_row_end
		or (current_row == target_row_start and current_col < target_col_start)
		or (current_row == target_row_end and current_col > target_col_end)
end

function M.get_filename_fn()
	local bufnr_name_cache = {}
	return function(bufnr)
		bufnr = vim.F.if_nil(bufnr, 0)
		local c = bufnr_name_cache[bufnr]
		if c then
			return c
		end

		local n = vim.api.nvim_buf_get_name(bufnr)
		bufnr_name_cache[bufnr] = n
		return n
	end
end

function M.open_result_in_current_window(result)
	local uri = result.uri or result.targetUri
	local range = result.range or result.targetRange
	vim.api.nvim_win_set_buf(0, vim.uri_to_bufnr(uri))
	vim.api.nvim_win_set_cursor(0, { range.start.line + 1, range.start.character })
end

return M