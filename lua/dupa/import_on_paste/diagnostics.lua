local log = require("dupa.log")
local utils = require("dupa.import_on_paste.utils")
local M = {}

local function is_between_positions(position, start_position, end_position)
	return position[1] >= start_position[1]
		and position[1] <= end_position[1]
		and (position[1] ~= start_position[1] or position[2] >= start_position[2])
		and (position[1] ~= end_position[1] or position[2] <= end_position[2])
end

local function convert_diagnostic_start_position(diagnostic)
	return { diagnostic.lnum + 1, diagnostic.col }
end

function M.get_all_missing_import_diagnostics_from_range(start_position, end_position)
	-- get all diagnostics in file after paste
	local diagnostics = vim.diagnostic.get()
	log.trace("initial: ", start_position, end_position)

	-- find all diagnostics that contains 'Cannot find name' error messagse
	-- TODO make sure that those diagnostics are in pasted range
	local missing_import_diagnostics = vim.tbl_filter(function(diagnostic)
		local diagnostic_start_position = convert_diagnostic_start_position(diagnostic)
		log.trace(
			diagnostic.source,
			vim.inspect(diagnostic_start_position),
			is_between_positions(diagnostic_start_position, start_position, end_position)
		)

		if not is_between_positions(diagnostic_start_position, start_position, end_position) then
			return false
		end

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