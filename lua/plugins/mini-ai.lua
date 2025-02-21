return {
  "KostkaBrukowa/mini.ai",
  -- cond = not vim.g.vscode,
  dependencies = {
    "echasnovski/mini.bufremove",
  },
  config = function()
    require("mini.ai").setup({
      n_lines = 500,
    })
  end,
}
