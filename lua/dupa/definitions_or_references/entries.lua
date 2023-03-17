local telescope_utils = require("telescope.utils")
local utils = require("dupa.definitions_or_references.utils")
local entry_display = require("telescope.pickers.entry_display")
local make_entry = require("telescope.make_entry")

local function make_entry_filename(entry)
	local filename_split = vim.split(entry.filename, "/", { trimempty = true })
	local two_last_path_parts = (filename_split[#filename_split - 1] .. "/" .. filename_split[#filename_split])

	local filename = (entry.value.is_inside_import and "-Import- " or "")
		.. (entry.value.is_test_file and "-Test- " or "")
		.. two_last_path_parts

	return filename
end

local function make_telescope_entries_from()
	local configuration = {
		{ width = 30 },
		{ remaining = true },
	}

	local displayer = entry_display.create({ separator = " ▏", items = configuration })

	local make_display = function(entry)
		return displayer({
			string.format("%s", make_entry_filename(entry)),
			-- trim text from both sides
			entry.text:gsub("^%s*(.-)%s*$", "%1"):gsub(".* | ", ""),
		})
	end

	local get_filename = utils.get_filename_fn()

	return function(entry)
		local filename = vim.F.if_nil(entry.filename, get_filename(entry.bufnr))

		return make_entry.set_default_entry_mt({
			value = entry,
			ordinal = filename .. " " .. entry.text,
			display = make_display,

			bufnr = entry.bufnr,
			filename = filename,
			lnum = entry.lnum,
			col = entry.col,
			text = entry.text,
			start = entry.start,
			finish = entry.finish,
		}, {})
	end
end

return {
	make_telescope_entries_from = make_telescope_entries_from,
}
