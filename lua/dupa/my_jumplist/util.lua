local log = require("dupa.log-mock")
local M = {}

--- @param a table
--- @param b table
function M.jumps_equal(a, b)
	if not a or not b then
		return false
	end
	local cursorA = a.cursor_position
	local cursorB = b.cursor_position
	return cursorA[1] == cursorB[1] and cursorA[2] == cursorB[2] and a.file_name == b.file_name
end

function M.make_current_position_entry()
	local jump = { cursor_position = vim.api.nvim_win_get_cursor(0), file_name = vim.fn.expand("%p") }
	return jump
end

function M.should_skip_file(file)
	if
		file == ""
		-- or string.find(file, "NvimTree_")
		-- or string.find(file, "nvim/runtime/doc")
		-- or string.find(file, "fugitive:")
		-- or string.find(file, "spectre")
		-- or string.find(file, "COMMIT_")
		-- or string.find(file, "#toggleterm#")
	then
		log.trace("should_skip_file: file name is empty")
		return true
	end
end

return M