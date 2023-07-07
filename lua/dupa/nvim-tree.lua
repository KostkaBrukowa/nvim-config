local nvim_tree = safe_require("nvim-tree")

if not nvim_tree then
  return
end

local nvim_tree_config = safe_require("nvim-tree.config")

if not nvim_tree_config then
  return
end

local telescope_utils = require("utils.telescope-custom-pickers")
local gwidth = vim.api.nvim_list_uis()[1].width
local gheight = vim.api.nvim_list_uis()[1].height
local width = math.floor(gwidth * 0.6)
local height = math.floor(gheight * 0.95)

local function on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))

  vim.keymap.set("n", "<esc>", api.tree.close, opts("Close"))
  vim.keymap.set("n", "E", "", { buffer = bufnr })
  vim.keymap.del("n", "E", { buffer = bufnr })
  vim.keymap.set("n", "e", "", { buffer = bufnr })
  vim.keymap.del("n", "e", { buffer = bufnr })

  vim.keymap.set("n", "<Right>", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "<Left>", api.node.navigate.parent_close, opts("Close Directory"))
  vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
  vim.keymap.set("n", "<leader>ff", function()
    telescope_utils.find_in_focused_file(api.tree.get_node_under_cursor())
  end, opts("Find in folder"))

  vim.keymap.set("n", "<leader>fp", function()
    telescope_utils.find_file_in_focused_file(api.tree.get_node_under_cursor())
  end, opts("Find file in folder"))
end

nvim_tree.setup({
  on_attach = on_attach,
  hijack_netrw = false,
  view = {
    width = 45,
    side = "right",
    preserve_window_proportions = true,
    float = {
      enable = true,
      open_win_config = {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((gheight - height) * 0.2),
        col = math.floor(gwidth * 0.2),
      },
    },
  },
  filters = {
    custom = { "\\.git$" },
    exclude = { ".gitignore", "scenarios.private.js" },
  },
  renderer = {
    root_folder_label = false,
    add_trailing = false,
    group_empty = false,
    highlight_opened_files = "none",
    root_folder_modifier = ":t",
    icons = {
      webdev_colors = true,
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = false,
      },
    },
  },

  git = { enable = false },
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
})

local api = require("nvim-tree.api")
api.events.subscribe(api.events.Event.FileCreated, function(file)
  vim.cmd("edit " .. file.fname)
end)
