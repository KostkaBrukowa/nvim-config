return {
  "numToStr/Comment.nvim",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    require("Comment").setup({
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    })
  end,
  keys = {
    {
      "<leader>/",
      function()
        return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)j"
          or "<Plug>(comment_toggle_linewise_count)"
      end,
      desc = "Comment toggle linewise",
      expr = true,
    },
    {
      "<leader>/",
      "<Plug>(comment_toggle_linewise_visual)",
      desc = "Comment toggle linewise visual",
      mode = "v",
    },
  },
}
