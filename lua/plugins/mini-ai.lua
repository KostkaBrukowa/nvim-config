return {
  "KostkaBrukowa/mini.ai",
  dependencies = {
    "echasnovski/mini.bufremove",
  },
  config = function()
    require("mini.ai").setup({
      n_lines = 500,
    })
  end,
}
