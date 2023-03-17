local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local methods = require("dupa.definitions_or_references.consts").methods
local sorter = require("dupa.definitions_or_references.sorter")
local entries = require("dupa.definitions_or_references.entries")

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

local function references()
	local params = vim.lsp.util.make_position_params(0)

	params.context = { includeDeclaration = true }

	vim.lsp.buf_request(0, methods.references.name, params, function(err, result, ctx, _)
		if err or not result then
			vim.api.nvim_err_writeln("Error when finding references: " .. err.message)
			return
		end

		local qf_list_items =
			vim.lsp.util.locations_to_items(result, vim.lsp.get_client_by_id(ctx.client_id).offset_encoding)
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
					entry_maker = entries.make_telescope_entries_from({}),
				}),
				previewer = require("telescope.config").values.qflist_previewer({}),
				sorter = sorter,
				push_cursor_on_edit = true,
				push_tagstack_on_edit = true,
				initial_mode = "normal",
			})
			:find()
	end)
end

return references
