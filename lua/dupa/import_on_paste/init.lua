local import_on_paste_group = vim.api.nvim_create_augroup("import_on_paste_group", {})
local keymap_amend = require("keymap-amend")
local log = require("dupa.log")
local parsers = require("nvim-treesitter.parsers")
local ts_utils = require("nvim-treesitter.ts_utils")
local path = require("plenary.path")

-- chat-gpt wrote it
local function relative_path(a, b)
	local sep = "/"
	local i = 1

	-- split paths into segments
	local a_segments = {}
	for seg in string.gmatch(a, "[^" .. sep .. "]+") do
		a_segments[i] = seg
		i = i + 1
	end

	local b_segments = {}
	i = 1
	for seg in string.gmatch(b, "[^" .. sep .. "]+") do
		b_segments[i] = seg
		i = i + 1
	end

	-- find the common path segments
	local j = 1
	while a_segments[j] == b_segments[j] do
		j = j + 1
	end

	-- build relative path
	local rel_path = ""
	-- in the future add to if j == #a_segments
	if #a_segments <= #b_segments and a_segments[#a_segments - 1] == b_segments[#a_segments - 1] then
		rel_path = "./"
	end

	for k = j, #a_segments - 1 do
		rel_path = rel_path .. "../"
	end
	for k = j, #b_segments do
		rel_path = rel_path .. b_segments[k] .. sep
	end
	rel_path = string.sub(rel_path, 1, -2) -- remove trailing separator

	return rel_path
end

local function get_directory(file_path)
	local sep = "/"
	local segments = {}
	local i = 1

	-- split path into segments
	for seg in string.gmatch(file_path, "[^" .. sep .. "]+") do
		segments[i] = seg
		i = i + 1
	end

	-- remove filename from segments
	table.remove(segments)

	-- build directory path
	local directory_path = ""
	for i = 1, #segments do
		directory_path = directory_path .. segments[i] .. sep
	end

	return directory_path
end

local last_yank_filename = nil

local on_yank_post = function()
	-- TODO some more sophisticated yank storage
	last_yank_filename = vim.fn.expand("%:p")
end

--[[
--example diagnostic
{
    bufnr = 13,
    code = 2304,
    col = 2,
    end_col = 13,
    end_lnum = 31,
    lnum = 31,
    message = "Cannot find name 'formatMoney'.",
    namespace = 44,
    severity = 1,
    source = "tsserver",
    user_data = {
      lsp = {
        code = 2304
      }
    }
  }
]]
--

local on_paste = function()
	log.trace("Starting on paste with: " .. vim.inspect(last_yank_filename))
	if not last_yank_filename then
		return
	end

	-- get all diagnostics in file after paste
	local diagnostics = vim.diagnostic.get()
	-- log.trace("diagnostics " .. vim.inspect(diagnostics))

	-- find all diagnostics that contains 'Cannot find name' error messagse
	-- TODO make sure that those diagnostics are in pasted range
	local missing_import_diagnostics = vim.tbl_filter(function(diagnostic)
		return string.find(diagnostic.message, "Cannot find name")
	end, diagnostics)

	if #missing_import_diagnostics == 0 then
		log.trace("missing_import_diagnostics not found")
		return
	end

	log.trace("found missing_import_diagnostics", vim.inspect(missing_import_diagnostics))

	-- if so read last_yank_filename file and parse with tree-sitter
	local bufnr = vim.uri_to_bufnr(vim.uri_from_fname(last_yank_filename))
	if not vim.api.nvim_buf_is_loaded(bufnr) then
		vim.fn.bufload(bufnr)
	end

	local lang = parsers.get_buf_lang(bufnr)
	local language_tree = parsers.get_parser(bufnr, lang)
	local root = ts_utils.get_root_for_position(1, 1, language_tree)

	local all_import_names_query = vim.treesitter.parse_query(
		lang,
		[[
    ; import { import_name } from '...'
    (import_statement (import_clause (named_imports (import_specifier (identifier) @import_name))))

    ; import import_name from '...'
    (import_statement (import_clause (identifier) @import_name))

    ; import * as import_name from '...'
    (import_statement (import_clause (namespace_import (identifier) @import_name)))
  ]]
	)

	local import_name_nodes = {}
	for _, import_name, _ in all_import_names_query:iter_captures(root, bufnr, root:start(), root:end_()) do
		table.insert(import_name_nodes, import_name)
	end

	-- fail fast if empty
	log.trace("import_name_nodes", #import_name_nodes)

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

	-- for each name in found diagnostics find this name in import list
	local import_nodes_to_add = {}
	for _, diagnostic in ipairs(missing_import_diagnostics) do
		local missing_import_name = string.match(diagnostic.message, "Cannot find name '(.*)'")

		if missing_import_name then
			log.trace("missing_import_name", missing_import_name)

			for _, import_name_node in pairs(import_name_nodes) do
				local import_name_text = vim.treesitter.get_node_text(import_name_node, bufnr)

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

	-- todo
	local function is_global_import(import_text)
		return string.find(import_text, "^@/")
	end

	-- TODO
	local function correct_import_path(import_node, source_file_directory)
		local import_string_node = import_node:named_child(1)

		if not import_string_node or import_string_node:type() ~= "string" then
			log.trace("import_string_node not found")
		end

		local import_content_node = import_string_node:named_child(0)

		if not import_content_node or import_content_node:type() ~= "string_fragment" then
			log.trace("import_content_node not found")
		end

		local import_text = vim.treesitter.get_node_text(import_content_node, bufnr)
		local full_import_text = vim.treesitter.get_node_text(import_node, bufnr)

		if is_global_import(import_text) then
			return full_import_text
		end

		local file_to_import_full_path = "/" .. path:new(source_file_directory .. import_text):normalize()

		local relative_path_to_import = relative_path(vim.fn.expand("%:p"), file_to_import_full_path)

		local result = string.gsub(full_import_text, import_text, relative_path_to_import)

		log.trace("adding replaced import: " .. vim.inspect(result))

		return result
	end

	-- copy whole import of this name and paste it to current file and change to correct path if neccessary
	local source_file_directory = get_directory(last_yank_filename)

	local corrected_imports = vim.tbl_map(function(import_node)
		local corrected_path = correct_import_path(import_node, source_file_directory)
		return corrected_path:gsub("\n", "")
	end, import_nodes_to_add)

	vim.api.nvim_buf_set_lines(0, 0, 0, true, corrected_imports)

	-- run typescript organize imports to remove duplicates
	vim.api.nvim_command("TSToolsOrganizeImports")
end

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	group = import_on_paste_group,
	pattern = "*",
	callback = on_yank_post,
})

vim.api.nvim_create_autocmd("User", {
	group = import_on_paste_group,
	pattern = "import_on_paste",
	callback = on_paste,
})

keymap_amend("n", "p", function(original)
	original()
	-- TODO change defer to waiting for diagnostics to show up
	vim.defer_fn(function()
		vim.cmd("doautocmd User import_on_paste")
	end, 1000)
end)
