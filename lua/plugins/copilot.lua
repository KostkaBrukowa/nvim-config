return {
  "github/copilot.vim",
  config = function()
    vim.g.copilot_no_tab_map = true
  end,
  lazy = false,
  keys = {
    {
      "<Right>",
      'copilot#Accept("\\<Right>")',
      expr = true,
      replace_keycodes = false,
      silent = true,
      mode = "i",
    },
    { "<C-l>", "<Plug>(copilot-next)", mode = "i" },
    { "<C-u>", "<Plug>(copilot-previous)", mode = "i" },
    { "<C-y>", "<Plug>(copilot-suggest)", mode = "i" },
    { "<C-e>", "<Plug>(copilot-cancel)", mode = "i" },
  },
}
