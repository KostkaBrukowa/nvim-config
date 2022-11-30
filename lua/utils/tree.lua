local nvim_tree_api = safe_require("nvim-tree.api").tree

local M = {}

function M.is_buffer_nvim_tree(bufnr)
	local currentBuffer = string.lower(vim.api.nvim_buf_get_name(bufnr))
	return string.find(currentBuffer, "nvimtree")
end

function M.focusOrToggleIfFocused()
	local isNvimTreeFocused = M.is_buffer_nvim_tree(0)

	if isNvimTreeFocused == nil then
		nvim_tree_api.focus()
	else
		nvim_tree_api.toggle()
	end
end

return M
