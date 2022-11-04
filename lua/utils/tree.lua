local nvim_tree_api = safe_require("nvim-tree.api").tree

local M = {}

function M.focusOrToggleIfFocused()
	local currentBuffer = string.lower(vim.api.nvim_buf_get_name(0))
	local isNvimTreeFocused = string.find(currentBuffer, "nvimtree")

	if isNvimTreeFocused == nil then
		nvim_tree_api.focus()
	else
		nvim_tree_api.toggle()
	end
end

return M
