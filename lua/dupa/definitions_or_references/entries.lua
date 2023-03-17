local telescope_utils = require("telescope.utils")
local utils = require("dupa.definitions_or_references.utils")
local entry_display = require("telescope.pickers.entry_display")
local make_entry = require("telescope.make_entry")

local function make_telescope_entries_from(opts)
	opts = opts or {}

	local hidden = telescope_utils.is_path_hidden(opts)
	local items = {
		{ width = vim.F.if_nil(opts.fname_width, 30) },
		{ remaining = true },
	}
	if hidden then
		items[1] = { width = 8 }
	end

	local displayer = entry_display.create({ separator = " ▏", items = items })

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

	local get_filename = utils.get_filename_fn()

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

return {
	make_telescope_entries_from = make_telescope_entries_from,
}
