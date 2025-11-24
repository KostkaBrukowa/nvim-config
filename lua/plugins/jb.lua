return {
  "nickkadutskyi/jb.nvim",
  cond = not vim.g.vscode,
  lazy = false,
  priority = 1000,
  opts = {
    -- transparent = true, -- Uncomment for transparent background
  },
  config = function(_, opts)
    require("jb").setup(opts)
    -- vim.cmd([[colorscheme tokyonight]])
    -- vim.cmd([[colorscheme jb]])

    -- Uncomment to use light theme
    -- vim.o.background = "light"
  end,
}
