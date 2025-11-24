return {
  "KostkaBrukowa/copilot-cli.nvim",
  cmd = "Copilot",
  keys = {
    { "<leader>a/", "<cmd>Copilot toggle<cr>", desc = "Toggle Copilot CLI" },
    { "<leader>aa", "<cmd>Copilot ask<cr>", desc = "Ask Copilot", mode = { "n", "v" } },
    { "<leader>af", "<cmd>Copilot add_file<cr>", desc = "Add File" },
  },
  dependencies = {
    "folke/snacks.nvim",
  },
  config = true,
}