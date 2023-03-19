local log = require("dupa.log-mock")
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

local function find_full_import_statement(node)
	local parent = node:parent()

	while parent ~= nil do
		if parent:type() == "import_statement" then
			return parent
		end

		parent = parent:parent()
	end

	return nil
end

local function find_all_import_specifiers_nodes(source_bufnr)
	local lang = parsers.get_buf_lang(source_bufnr)
	local root = ts_utils.get_root_for_position(1, 1, parsers.get_parser(source_bufnr, lang))

	local all_import_names_query = vim.treesitter.parse_query(lang, IMPORTS_QUERY)

	local import_name_nodes = {}
	for _, import_name, _ in all_import_names_query:iter_captures(root, source_bufnr, root:start(), root:end_()) do
		table.insert(import_name_nodes, import_name)
	end

	return import_name_nodes
end

local function find_full_import_for_name(missing_import_name, all_import_specifiers_nodes, source_bufnr)
	log.trace("missing_import_name", missing_import_name)

	if not missing_import_name then
		return nil
	end

	for _, import_specifier_node in pairs(all_import_specifiers_nodes) do
		local import_specifier_text = vim.treesitter.get_node_text(import_specifier_node, source_bufnr)

		if missing_import_name == import_specifier_text then
			log.trace("Found import for: ", missing_import_name)
			local import_statement_node = find_full_import_statement(import_specifier_node)
			if import_statement_node then
				return import_statement_node
			end
		end
	end

	return nil
end

--- @return table
function M.find_missing_import_nodes(source_bufnr, missing_import_diagnostics)
	local all_import_specifiers_nodes = find_all_import_specifiers_nodes(source_bufnr)

	if #all_import_specifiers_nodes == 0 then
		log.error("No import nodes found in source file")
		return {}
	end

	-- for each name in found diagnostics find this name in import list
	local import_nodes_to_add = {}
	for _, diagnostic in ipairs(missing_import_diagnostics) do
		local missing_import_name = string.match(diagnostic.message, utils.constants.MISSING_IMPORT_DIAGNOSTIC_MESSAGE)

		local import_for_missing_name =
			find_full_import_for_name(missing_import_name, all_import_specifiers_nodes, source_bufnr)

		if import_for_missing_name then
			table.insert(import_nodes_to_add, import_for_missing_name)
		end
	end

	return import_nodes_to_add
end

return M
