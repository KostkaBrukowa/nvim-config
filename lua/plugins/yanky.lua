return {
  "gbprod/yanky.nvim",
  -- cond = not vim.g.vscode,
  opts = {
    highlight = {
      on_put = false,
      on_yank = true,
      timer = 300,
    },
    history_length = 20,
    picker = {
      select = {
        action = function(content)
          require("yanky.picker").actions.put("p", false)(content)
          require("yanky.picker").actions.set_register('"')(content)
        end,
      },
    },
  },
}
