local telescope = require("telescope")
local telescope_utils = require("utils.telescope-utils")
local actions = require("telescope.actions")
local actions_set = require("telescope.actions.set")
local entry_display = require("telescope.pickers.entry_display")

if not telescope then
  return
end

if not actions then
  return
end

if not actions_set then
  return
end

local grep_entry_maker = function(entry)
  local res = require("telescope.make_entry").gen_from_vimgrep()(entry)
  local configuration = {
    { width = 80 },
    {},
    {},
    {},
    {},
    {},
  }

  local displayer = entry_display.create({ separator = "", items = configuration })

  res.display = function(entry_tbl)
    local _, _, filename, pos, text = string.find(entry_tbl[1], "^(.*):(%d+:%d+):(.*)$")
    local icon, dir, name = telescope_utils.refine_filename(filename)

    return displayer({ { text }, icon, dir, name, { " " .. pos, "TelescopeResultsLineNr" } })
  end
  return res
end

telescope.setup({
  pickers = {
    live_grep = {
      entry_maker = grep_entry_maker,
      additional_args = { "--trim", "--hidden" },
    },
    oldfiles = {
      cwd_only = false,
      initial_mode = "normal",
    },
    find_files = {
      hidden = true,
      previewer = false,
    },
  },
  defaults = {
    layout_strategy = "vertical",
    cache_picker = {
      num_pickers = 3,
    },
    file_ignore_patterns = {
      ".git/",
      "node_modules/*",
      "lazy-lock.json",
    },
    mappings = {
      i = {
        ["<ESC>"] = actions.close,
        ["<A-ESC>"] = function()
          vim.cmd("stopinsert")
        end,
        ["<C-Tab>"] = actions.move_selection_previous,
        ["<A-Tab>"] = actions.move_selection_previous,
        ["<Tab>"] = actions.select_default,
        ["<C-e>"] = actions.preview_scrolling_up,
        ["<C-n>"] = actions.preview_scrolling_down,
        ["<F20>"] = actions.select_default,
      },
      n = {
        ["e"] = actions.move_selection_previous,
        ["n"] = actions.move_selection_next,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "ignore_case",
    },
  },
})

telescope.load_extension("fzf")
telescope.load_extension("project")
telescope.load_extension("yank_history")
telescope.load_extension("textcase")
