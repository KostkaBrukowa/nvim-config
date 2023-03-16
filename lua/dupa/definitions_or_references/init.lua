-- improvement - start references call with definitions call to speed up
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local entry_display = require("telescope.pickers.entry_display")
local telescope_utils = require("telescope.utils")

local log = require("dupa.log")
local methods = {
	definitions = { name = "textDocument/definition", cancel_function = nil },
	references = { name = "textDocument/references", cancel_function = nil },
}

local function current_cursor_not_on_result(result)
	local target_uri = result.targetUri or result.uri
	local target_range = result.targetRange or result.range

	local target_bufnr = vim.uri_to_bufnr(target_uri)
	local target_row_start = target_range.start.line + 1
	local target_row_end = target_range["end"].line + 1
	local target_col_start = target_range.start.character + 1
	local target_col_end = target_range["end"].character + 1

	local current_bufnr = vim.fn.bufnr("%")
	local current_range = vim.api.nvim_win_get_cursor(0)
	local current_row = current_range[1]
	local current_col = current_range[2] + 1 -- +1 because if cursor highlights first character its a column behind

	return target_bufnr ~= current_bufnr
		or current_row < target_row_start
		or current_row > target_row_end
		or (current_row == target_row_start and current_col < target_col_start)
		or (current_row == target_row_end and current_col > target_col_end)
end

local get_filename_fn = function()
	local bufnr_name_cache = {}
	return function(bufnr)
		bufnr = vim.F.if_nil(bufnr, 0)
		local c = bufnr_name_cache[bufnr]
		if c then
			return c
		end

		local n = vim.api.nvim_buf_get_name(bufnr)
		bufnr_name_cache[bufnr] = n
		return n
	end
end

local fuzzy_sorter = sorters.get_generic_fuzzy_sorter()
local sorter = sorters.Sorter:new({
	scoring_function = function(_, prompt, line, entry, cb_add, cb_filter)
		local base_score = fuzzy_sorter:scoring_function(prompt, line, cb_add, cb_filter)

		if entry.value.is_test_file then
			base_score = base_score + 100
		end

		if entry.value.is_inside_import then
			base_score = base_score + 100
		end

		return base_score
	end,
	highlighter = fuzzy_sorter.highlighter,
})

local function gen_from_quickfix(opts)
	opts = opts or {}

	local hidden = telescope_utils.is_path_hidden(opts)
	local items = {
		{ width = vim.F.if_nil(opts.fname_width, 30) },
		{ remaining = true },
	}
	if hidden then
		items[1] = { width = 8 }
	end

	local displayer = entry_display.create({ separator = "▏", items = items })

	local make_display = function(entry)
		local input = {}
		if not hidden then
			local filename_split = vim.split(entry.filename, "/", { trimempty = true })
			local last_two_paths = (filename_split[#filename_split - 1] .. "/" .. filename_split[#filename_split])

			local result = (entry.value.is_inside_import and "-Import- " or "")
				.. (entry.value.is_test_file and "-Test- " or "")
				.. last_two_paths

			table.insert(input, string.format("%s", result))
		else
			table.insert(input, string.format("%4d:%2d", entry.lnum, entry.col))
		end

		local text = entry.text

		--trim text
		text = text:gsub("^%s*(.-)%s*$", "%1")

		text = text:gsub(".* | ", "")
		table.insert(input, text)

		return displayer(input)
	end

	local get_filename = get_filename_fn()
	return function(entry)
		local filename = vim.F.if_nil(entry.filename, get_filename(entry.bufnr))

		return make_entry.set_default_entry_mt({
			value = entry,
			ordinal = (not hidden and filename or "") .. " " .. entry.text,
			display = make_display,

			bufnr = entry.bufnr,
			filename = filename,
			lnum = entry.lnum,
			col = entry.col,
			text = entry.text,
			start = entry.start,
			finish = entry.finish,
		}, opts)
	end
end

local function references()
	local filepath = vim.api.nvim_buf_get_name(0)
	local lnum = vim.api.nvim_win_get_cursor(0)[1]
	local params = vim.lsp.util.make_position_params()
	-- TODO find what it does
	-- params.context = { includeDeclaration = vim.F.if_nil(opts.include_declaration, true) }

	vim.lsp.buf_request(0, methods.references.name, params, function(err, result, ctx, _)
		if err then
			vim.api.nvim_err_writeln("Error when finding references: " .. err.message)
			return
		end

		local locations = {}
		if result then
			local results =
				vim.lsp.util.locations_to_items(result, vim.lsp.get_client_by_id(ctx.client_id).offset_encoding)
			locations = vim.tbl_filter(function(v)
				-- Remove current line from result
				if v.filename == filepath and v.lnum == lnum then
					return false
				end

				-- if is closing tag - just before it there is a closing tag syntax '</'
				if
					v.col > 2
					and v.text:sub(v.col - 2, v.col - 2) == "<"
					and v.text:sub(v.col - 1, v.col - 1) == "/"
				then
					return false
				end

				return true
			end, vim.F.if_nil(results, {}))
		end

		if vim.tbl_isempty(locations) then
			return
		end

		if #locations == 1 then
			-- jump to location
			local location = locations[1]
			local bufnr = 0
			if location.filename then
				bufnr = vim.uri_to_bufnr(vim.uri_from_fname(location.filename))
			end
			vim.api.nvim_win_set_buf(0, bufnr)
			vim.api.nvim_win_set_cursor(0, { location.lnum, location.col - 1 })
			return
		end

		locations = vim.tbl_map(function(location)
			if string.find(location.text, "^import") then
				location.is_inside_import = true
			end

			if string.find(location.filename, ".spec.") or string.find(location.filename, "TestBuilder") then
				location.is_test_file = true
			end

			return location
		end, locations)

		pickers
			.new({}, {
				prompt_title = "LSP References",
				finder = finders.new_table({
					results = locations,
					entry_maker = gen_from_quickfix({}),
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

local function definition_or_references()
	local params = vim.lsp.util.make_position_params()

	vim.lsp.buf_request(0, methods.definitions.name, params, function(err, result, ctx, _)
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

		local only_reference = result[1]

		if current_cursor_not_on_result(only_reference) then
			log.trace("Current cursor not on result")
			vim.api.nvim_win_set_buf(0, vim.uri_to_bufnr(only_reference.uri))
			vim.api.nvim_win_set_cursor(
				0,
				{ only_reference.range.start.line + 1, only_reference.range.start.character }
			)
			return
		end

		log.trace("Current cursor on only reference")

		references()
	end)
end

local ASquareRight = vim.fn.has("macunix") == 1 and "≥" or "<A->>"
vim.api.nvim_set_keymap(
	"n",
	ASquareRight,
	"<cmd>lua require('dupa.definitions_or_references').definitions_or_references()<CR>",
	{ silent = true }
)

return {
	definitions_or_references = definition_or_references,
}
