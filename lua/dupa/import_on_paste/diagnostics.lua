local log = require("dupa.log")
local utils = require("dupa.import_on_paste.utils")
local M = {}

function M.get_all_missing_import_diagnostics_from_range(range)
	-- get all diagnostics in file after paste
	local diagnostics = vim.diagnostic.get()

	-- find all diagnostics that contains 'Cannot find name' error messagse
	-- TODO make sure that those diagnostics are in pasted range
	local missing_import_diagnostics = vim.tbl_filter(function(diagnostic)
		return string.find(diagnostic.message, utils.constants.MISSING_IMPORT_DIAGNOSTIC_MESSAGE)
	end, diagnostics)

	if #missing_import_diagnostics == 0 then
		log.trace("missing_import_diagnostics not found")
		return {}
	end

	log.trace("found missing_import_diagnostics", vim.inspect(missing_import_diagnostics))

	return missing_import_diagnostics
end

return M
