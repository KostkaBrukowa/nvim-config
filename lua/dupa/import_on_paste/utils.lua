local M = {}

M.constants = {
	MISSING_IMPORT_DIAGNOSTIC_MESSAGE = "Cannot find name '(.*)'",
	REACT_IMPORT_MISSING = "'(.*)' refers to a UMD global, but the current file is a module. Consider adding an import instead.",
}

function M.get_bufnr_from_filename(filename)
	local bufnr = vim.uri_to_bufnr(vim.uri_from_fname(filename))
	if not vim.api.nvim_buf_is_loaded(bufnr) then
		vim.fn.bufload(bufnr)
	end

	return bufnr
end

return M
