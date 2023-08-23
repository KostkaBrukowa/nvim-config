return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen" },
  opts = {
    enhanced_diff_hl = true,
    keymaps = {
      view = {
        ["<leader>co"] = false,
        ["<leader>ct"] = false,
        ["<leader>cb"] = false,
        ["<leader>ca"] = false,
        ["<leader>cO"] = false,
        ["<leader>cT"] = false,
        ["<leader>cB"] = false,
        ["<leader>cA"] = false,
      },
      file_panel = {
        ["<leader>cO"] = false,
        ["<leader>cT"] = false,
        ["<leader>cB"] = false,
        ["<leader>cA"] = false,
      },
    },
    hooks = {
      diff_buf_read = function(bufnr) end,
      view_opened = function()
        vim.cmd("UfoDisable")
      end,
      view_closed = function()
        vim.cmd("UfoEnable")
      end,
    },
  },
  config = function(_, opts)
    require("diffview").setup(opts)
  end,
  init = function()
    vim.api.nvim_create_user_command("DiffviewToggle", function(e)
      local view = require("diffview.lib").get_current_view()

      if view then
        vim.cmd("DiffviewClose")
      else
        vim.cmd("DiffviewOpen " .. e.args)
      end
    end, { nargs = "*" })
  end,
}
