return {
  "nvimtools/hydra.nvim",
  config = function()
    require("config.hydra.hydra-dap")
    require("config.hydra.hydra-windows")
  end,
}
