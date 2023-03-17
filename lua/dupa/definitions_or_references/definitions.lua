local log = require("dupa.log")
local methods = require("dupa.definitions_or_references.consts").methods
local util = require("dupa.definitions_or_references.utils")

local function definitions(references_callback)
	local params = vim.lsp.util.make_position_params(0)

	vim.lsp.buf_request(0, methods.definitions.name, params, function(err, result, _, _)
		-- send buf_request for references
		if err then
			vim.notify(err.message, vim.log.levels.ERROR)
			return
		end

		if #result == 0 then
			log.trace("No references found")
			return
		end

		-- simple fallback when more that 1 reference. Should not happen often
		-- Skipping for now - go only to to first definition
		-- if #result ~= 1 then
		-- 	log.trace("Found more than 1 reference", vim.inspect(result))
		-- 	vim.cmd([[Telescope lsp_definitions]])
		-- 	return
		-- end

		local only_definition = result[1]

		if util.current_cursor_not_on_result(only_definition) then
			log.trace("Current cursor not on result", vim.inspect(only_definition))
			util.open_result_in_current_window(only_definition)
			return
		end

		log.trace("Current cursor on only definition")

		references_callback()
	end)
end

return definitions
