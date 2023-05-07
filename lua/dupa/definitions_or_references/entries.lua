local telescope_utils = require("utils.telescope-utils")
local utils = require("dupa.definitions_or_references.utils")
local entry_display = require("telescope.pickers.entry_display")
local make_entry = require("telescope.make_entry")

local function get_specifiers(entry)
  local specifiers = (entry.value.is_inside_import and "[I] " or "")
    .. (entry.value.is_test_file and "[T] " or "")

  return specifiers
end

local function make_telescope_entries_from()
  local configuration = {
    { width = 3 },
    { width = 45 },
    { width = 15 },
    {},
    {},
    {},
    {},
  }

  local displayer = entry_display.create({ separator = "", items = configuration })

  local make_display = function(entry)
    local icon, dir, name = telescope_utils.refine_filename(entry.filename)
    local pos = " " .. entry.lnum .. ":" .. entry.col

    return displayer({
      icon,
      {
        get_specifiers(entry) .. name[1],
        entry.value.is_inside_import and "TelescopeResultsLineNr" or nil,
      },
      { dir[1], entry.value.is_inside_import and "TelescopeResultsLineNr" or dir[2] },
      "  ",
      {
        -- trim text from both sides
        entry.text:gsub("^%s*(.-)%s*$", "%1"):gsub(".* | ", ""),
        entry.value.is_inside_import and "TelescopeResultsLineNr" or nil,
      },
      { " " .. pos, "TelescopeResultsLineNr" },
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
      col = entry.col - 1,
      text = entry.text,
      start = entry.start,
      finish = entry.finish,
    }, {})
  end
end

return {
  make_telescope_entries_from = make_telescope_entries_from,
}
