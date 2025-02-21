return {
  "nvimtools/hydra.nvim",
  cond = not vim.g.vscode,
  config = function()
    require("config.hydra.hydra-dap")
    require("config.hydra.hydra-windows")
  end,
}
