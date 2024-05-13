local builtin = require("telescope.builtin")

vim.api.nvim_set_keymap("n", "<CR>", "<cmd>Neotree toggle reveal<CR>", {})

local M = {}

require("neo-tree").setup({
  reveal = "true",
  window = {
    position = "float",
    mappings = {
      ["<Right>"] = "open",
      ["<Left>"] = "close_node",
      ["e"] = "noop",
      ["H"] = "noop",
      ["w"] = "noop",
      ["y"] = "noop",
      ["/"] = "noop",
      ["z"] = "noop",
      ["c"] = "copy_to_clipboard",
      ["?"] = "fuzzy_finder",
      ["g?"] = "show_help",
      ["s"] = function(state)
        M.open_in_finder(state.tree:get_node())
      end,
      ["<leader>ff"] = function(state)
        M.find_in_focused_file(state.tree:get_node())
      end,
    },
  },
  filesystem = {
    follow_current_file = {
      enabled = true,
    },
    filtered_items = {
      visible = true, -- when true, they will just be displayed differently than normal items
    },
  },
  default_component_configs = {
    file_size = {
      enabled = false,
    },
    type = {
      enabled = false,
    },
    last_modified = {
      enabled = false,
    },
    symlink_target = {
      enabled = true,
    },
    git_status = {
      symbols = {
        -- Change type
        added = "✚",
        deleted = "",
        modified = "",
        renamed = "",
        -- Status type
        untracked = "u",
        ignored = "",
        unstaged = "",
        staged = "",
        conflict = "",
      },
    },
  },
})

-- If you are in nvimtree and you are focused on some folder this command
-- will open live grep only in this directory
M.find_in_focused_file = function(node)
  if node.type == "directory" then
    builtin.live_grep({
      search_dirs = { node.path },
      prompt_title = "Live grep: " .. node.path,
    })

    return
  end

  local parent = require("neotest.lib").files.parent(node.path)

  if parent ~= nil then
    builtin.live_grep({
      search_dirs = { parent },
      prompt_title = "Live grep: " .. parent,
    })
  end
end

M.open_in_finder = function(node)
  os.execute("open " .. node.path)
end

-- TODO
-- vim.keymap.set("n", "<leader>fp", function()
--   telescope_utils.find_file_in_focused_file(api.tree.get_node_under_cursor())
-- end, opts("Find file in folder"))
