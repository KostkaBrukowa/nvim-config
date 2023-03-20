local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local methods = require("dupa.definitions_or_references.methods_state")
local sorter = require("dupa.definitions_or_references.sorter")
local entries = require("dupa.definitions_or_references.entries")
local utils = require("dupa.definitions_or_references.utils")
local log = require("dupa.log")

local function filter_entries(results)
	local current_file = vim.api.nvim_buf_get_name(0)
	local current_line = vim.api.nvim_win_get_cursor(0)[1]

	local function should_include_entry(entry)
		-- if entry is on the same line
		if entry.filename == current_file and entry.lnum == current_line then
			return false
		end

		-- if entry is closing tag - just before it there is a closing tag syntax '</'
		if entry.col > 2 and entry.text:sub(entry.col - 2, entry.col - 1) == "</" then
			return false
		end

		return true
	end

	return vim.tbl_filter(should_include_entry, vim.F.if_nil(results, {}))
end

local function open_location_in_current_window(location)
	local bufnr = 0

	if location.filename then
		bufnr = vim.uri_to_bufnr(vim.uri_from_fname(location.filename))
	end

	vim.api.nvim_win_set_buf(0, bufnr)
	vim.api.nvim_win_set_cursor(0, { location.lnum, location.col - 1 })
	require("dupa.my_jumplist").push_new_entry_to_jumplist()
end

--- @return table
local function add_metadata_to_locations(locations)
	return vim.tbl_map(function(location)
		if string.find(location.text, "^import") then
			location.is_inside_import = true
		end

		if string.find(location.filename, ".spec.") or string.find(location.filename, "TestBuilder") then
			location.is_test_file = true
		end

		return location
	end, locations)
end

local function handle_references_response()
	log.trace("handle_references_response")
	local result = methods.references.result

	methods.clear_references()

	if not result then
		vim.api.nvim_err_writeln("No references found")
		return
	end

	-- local qf_list_items =
	-- 	vim.lsp.util.locations_to_items(result, vim.lsp.get_client_by_id(ctx.client_id).offset_encoding)
	local qf_list_items = vim.lsp.util.locations_to_items(result, "utf-8")
	local locations = filter_entries(qf_list_items)

	if vim.tbl_isempty(locations) then
		vim.notify("No references found")
		return
	end

	if #locations == 1 then
		open_location_in_current_window(locations[1])
		return
	end

	pickers
		.new({}, {
			prompt_title = "LSP References",
			finder = finders.new_table({
				results = add_metadata_to_locations(locations),
				entry_maker = entries.make_telescope_entries_from(),
			}),
			previewer = require("telescope.config").values.qflist_previewer({}),
			sorter = sorter,
			push_cursor_on_edit = true,
			push_tagstack_on_edit = true,
			initial_mode = "normal",
		})
		:find()
end

local function send_references_request()
	_, methods.references.cancel_function = vim.lsp.buf_request(
		0,
		methods.references.name,
		utils.make_params(),
		function(err, result, _, _)
			-- sometimes when calcel function was called after request has been fulfilled this would be called
			-- if cancel_function is nil that means that references was cancelled
			if methods.references.cancel_function == nil then
				return
			end

			methods.references.is_pending = false

			if err then
				vim.notify(err.message, vim.log.levels.ERROR)
				return
			end

			methods.references.result = result

			if not methods.definitions.is_pending then
				log.trace("handle_references_response from send_references_request")
				handle_references_response()
			end
		end
	)

	methods.references.is_pending = true
end

return {
	send_references_request = send_references_request,
	handle_references_response = handle_references_response,
}
