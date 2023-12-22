local gwidth = vim.api.nvim_list_uis()[1].width
local gheight = vim.api.nvim_list_uis()[1].height
local width = math.floor(gwidth * 0.6)
local height = math.floor(gheight * 0.95)

local function on_attach(bufnr)
  local api = require("nvim-tree.api")
  local telescope_utils = require("utils.telescope-custom-pickers")

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

local opts = {
  on_attach = on_attach,
  hijack_netrw = false,
  view = {
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
  },

  git = { enable = false },
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
}

local api = require("nvim-tree.api")

-- open file after creating
api.events.subscribe(api.events.Event.FileCreated, function(file)
  vim.cmd("edit " .. file.fname)
end)

-- remove old buffers to prevent alternate file
api.events.subscribe(api.events.Event.NodeRenamed, function(data)
  for _, buf in pairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name == data.old_name then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end)

require("nvim-tree").setup(opts)
