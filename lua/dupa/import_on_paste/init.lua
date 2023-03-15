-- Possible improvements: instead of using OrganizeImports build imports yourself
-- if you've imported react components and react is not in scope import react
local keymap_amend = require("keymap-amend")

local log = require("dupa.log")
local path_utils = require("dupa.import_on_paste.path_utils")
local diagnostic = require("dupa.import_on_paste.diagnostics")
local utils = require("dupa.import_on_paste.utils")
local find_imports = require("dupa.import_on_paste.find_imports")
local correct_import_path = require("dupa.import_on_paste.correct_import_path")

local last_yank_filename = nil
local cursor_position_before_paste = nil
local cursor_position_after_paste = nil

local save_last_yank_filename = function()
	-- TODO some more sophisticated yank storage
	last_yank_filename = vim.fn.expand("%:p")
end

local add_missing_imports = function()
	log.trace("Starting on paste with: " .. vim.inspect(last_yank_filename))

	if not last_yank_filename then
		log.trace("Last yank filename was not found")
		return
	end

	-- get all diagnostics in file after paste
	local missing_import_diagnostics = diagnostic.get_all_missing_import_diagnostics_from_range(
		cursor_position_before_paste,
		cursor_position_after_paste
	)

	if not missing_import_diagnostics then
		return
	end

	-- read last_yank_filename file and parse with tree-sitter to find all imports
	local source_bufnr = utils.get_bufnr_from_filename(last_yank_filename)
	local import_nodes_to_add = find_imports.find_missing_import_nodes(source_bufnr, missing_import_diagnostics)

	local source_file_directory = path_utils.get_directory(last_yank_filename)
	local target_file_directory = path_utils.get_directory(vim.fn.expand("%:p"))

	-- correct relative paths in respect to current buffer
	local corrected_imports = vim.tbl_map(function(import_node)
		-- removing \n because nvim_buf_set_lines does not accept endlines
		return correct_import_path
			.correct_import_path(source_bufnr, import_node, source_file_directory, target_file_directory)
			:gsub("\n", "")
	end, import_nodes_to_add)

	-- add all corrected imports at the top of the file
	vim.api.nvim_buf_set_lines(0, 0, 0, true, corrected_imports)

	-- run typescript organize imports to remove duplicates only if something changed
	if #corrected_imports > 0 then
		vim.api.nvim_command("TSToolsOrganizeImports")
	end
end

local import_on_paste_group = vim.api.nvim_create_augroup("import_on_paste_group", {})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	group = import_on_paste_group,
	pattern = { "*.ts", "*.tsx" },
	callback = save_last_yank_filename,
})

keymap_amend("n", "p", function(original)
	cursor_position_before_paste = vim.api.nvim_win_get_cursor(0)

	vim.cmd("normal! gp")

	cursor_position_after_paste = vim.api.nvim_win_get_cursor(0)

	-- TODO change defer to waiting for diagnostics to show up
	vim.defer_fn(function()
		add_missing_imports()
	end, 1000)
end)
