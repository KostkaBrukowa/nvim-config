return {
  "anuvyklack/hydra.nvim",
  keys = { "<space>b", "<C-w>" },
  config = function()
    require("dupa.hydra.hydra-dap")
    require("dupa.hydra.hydra-windows")
  end,
}
