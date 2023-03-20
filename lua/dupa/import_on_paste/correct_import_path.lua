local path = require("plenary.path")
local log = require("dupa.log-mock")
local path_utils = require("dupa.import_on_paste.path_utils")

local M = {}

local function is_global_import(import_text)
	-- if import does not start with dot (like './' or '../'), it is global
	return not string.find(import_text, "^%.")
end

local function find_import_string_fragment(import_node)
	local import_string_node = import_node:named_child(1)

	if not import_string_node or import_string_node:type() ~= "string" then
		log.trace("import_string_node not found")
		return nil
	end

	local import_content_node = import_string_node:named_child(0)

	if not import_content_node or import_content_node:type() ~= "string_fragment" then
		log.trace("import_content_node not found")
		return nil
	end

	return import_content_node
end

function M.correct_import_path(bufnr, import_node, source_file_directory, target_file_directory)
	local full_import_text = vim.treesitter.get_node_text(import_node, bufnr)
	local import_path_node = find_import_string_fragment(import_node)

	if not import_path_node then
		return nil
	end

	local import_path = vim.treesitter.get_node_text(import_path_node, bufnr)

	if is_global_import(import_path) then
		log.trace("Import is global. Skipping correcting")
		return full_import_text
	end

	local import_full_path = path:new(source_file_directory .. import_path):normalize()
	local relative_path_to_import = path_utils.relative_path(target_file_directory, import_full_path)

	-- replace import path with new relative path
	local result = string.gsub(full_import_text, import_path, relative_path_to_import)

	log.trace("Corrected import: " .. vim.inspect(result))

	return result
end

return M
