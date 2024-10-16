local find_in_focused_file = function(node)
  if node.type == "directory" then
    require("telescope.builtin").live_grep({
      search_dirs = { node.path },
      prompt_title = "Live grep: " .. node.path,
    })

    return
  end

  local parent = require("neotest.lib").files.parent(node.path)

  if parent ~= nil then
    require("telescope.builtin").live_grep({
      search_dirs = { parent },
      prompt_title = "Live grep: " .. parent,
    })
  end
end

local open_in_finder = function(node)
  os.execute("open " .. node.path)
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    { "<CR>", "<cmd>Neotree toggle reveal<CR>", desc = "Open neotree" },
  },
  opts = {
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
          open_in_finder(state.tree:get_node())
        end,
        ["<leader>ff"] = function(state)
          find_in_focused_file(state.tree:get_node())
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
  },
}
