local M = {}

M.constants = {
	missing_import_messages = {
		"Cannot find name '(.*)'%.$",
		"'(.*)' is not defined%.",
		"Cannot find name '(.*)'%. Did you mean '.*'?$",
		"'(.*)' refers to a UMD global, but the current file is a module. Consider adding an import instead.",
		"'(.*)' must be in scope when using JSX",
	},
}

function M.is_missing_import_diagnostic(diagnostic)
	for _, message in pairs(M.constants.missing_import_messages) do
		if string.find(diagnostic.message, message) then
			return true
		end
	end

	return false
end

function M.get_bufnr_from_filename(filename)
	local bufnr = vim.uri_to_bufnr(vim.uri_from_fname(filename))
	if not vim.api.nvim_buf_is_loaded(bufnr) then
		vim.fn.bufload(bufnr)
	end

	return bufnr
end

return M
