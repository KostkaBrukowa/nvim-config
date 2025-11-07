return {
  "nvimtools/hydra.nvim",
  enabled = true,
  cond = not vim.g.vscode,
  config = function()
    require("config.hydra.hydra-windows")
    -- require("config.hydra.hydra-dap")
  end,
}
