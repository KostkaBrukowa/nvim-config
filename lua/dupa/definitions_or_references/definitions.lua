local log = require("dupa.log")
local methods = require("dupa.definitions_or_references.methods_state")
local util = require("dupa.definitions_or_references.utils")
local references = require("dupa.definitions_or_references.references")

local function definitions()
	vim.lsp.buf_request(0, methods.definitions.name, util.make_params(), function(err, result, _, _)
		methods.definitions.is_pending = false
		-- send buf_request for references
		if err then
			vim.notify(err.message, vim.log.levels.ERROR)
			return
		end

		if not result or #result == 0 then
			vim.notify("No definitions found")
			methods.clear_references()
			return
		end

		-- simple fallback when more that 1 reference. Should not happen often
		-- Skipping for now - go only to to first definition
		-- if #result ~= 1 then
		-- 	log.trace("Found more than 1 reference", vim.inspect(result))
		-- 	vim.cmd([[Telescope lsp_definitions]])
		-- 	return
		-- end

		local first_definition = result[1]

		if util.current_cursor_not_on_result(first_definition) then
			methods.clear_references()
			log.trace("Current cursor not on result")
			util.open_result_in_current_window(first_definition)
			return
		end

		log.trace("Current cursor on only definition")

		if not methods.references.is_pending then
			log.trace("handle_references_response from definitions")
			references.handle_references_response()
		end
	end)

	methods.definitions.is_pending = true
end

return definitions
