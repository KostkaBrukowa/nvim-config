local log = require("dupa.log")
local utils = require("dupa.import_on_paste.utils")
local parsers = require("nvim-treesitter.parsers")
local ts_utils = require("nvim-treesitter.ts_utils")
local M = {}

local IMPORTS_QUERY = [[
    ; import { import_name } from '...'
    (import_statement (import_clause (named_imports (import_specifier (identifier) @import_name))))

    ; import import_name from '...'
    (import_statement (import_clause (identifier) @import_name))

    ; import * as import_name from '...'
    (import_statement (import_clause (namespace_import (identifier) @import_name)))
]]

local function find_import_statement(node)
	local parent = node:parent()

	while parent ~= nil do
		if parent:type() == "import_statement" then
			return parent
		end

		parent = parent:parent()
	end

	return nil
end

local function find_all_import_nodes(lang, root, source_bufnr)
	local all_import_names_query = vim.treesitter.parse_query(lang, IMPORTS_QUERY)

	local import_name_nodes = {}
	for _, import_name, _ in all_import_names_query:iter_captures(root, source_bufnr, root:start(), root:end_()) do
		table.insert(import_name_nodes, import_name)
	end

	return import_name_nodes
end

--- @return table
function M.find_missing_import_nodes(source_bufnr, missing_import_diagnostics)
	local lang = parsers.get_buf_lang(source_bufnr)
	local root = ts_utils.get_root_for_position(1, 1, parsers.get_parser(source_bufnr, lang))

	local import_name_nodes = find_all_import_nodes(lang, root, source_bufnr)

	if #import_name_nodes == 0 then
		log.error("No import nodes found")
		return {}
	end

	-- for each name in found diagnostics find this name in import list
	local import_nodes_to_add = {}
	for _, diagnostic in ipairs(missing_import_diagnostics) do
		local missing_import_name = string.match(diagnostic.message, utils.constants.MISSING_IMPORT_DIAGNOSTIC_MESSAGE)

		if missing_import_name then
			log.trace("missing_import_name", missing_import_name)

			for _, import_name_node in pairs(import_name_nodes) do
				local import_name_text = vim.treesitter.get_node_text(import_name_node, source_bufnr)

				if import_name_text == missing_import_name then
					log.trace("import is equal to missing import name")
					local import_statement_node = find_import_statement(import_name_node)
					if import_statement_node then
						table.insert(import_nodes_to_add, import_statement_node)
					end
				end
			end
		end
	end

	return import_nodes_to_add
end

return M
