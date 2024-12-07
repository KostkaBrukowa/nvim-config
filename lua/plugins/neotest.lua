return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest-plenary",
    "nvim-neotest/neotest-jest",
    "marilari88/neotest-vitest",
    "folke/neoconf.nvim",
  },
  lazy = true,
  config = function()
    local configurationJestCommand = require("neoconf").get("jestRunCommand")
    local testRunner = require("neoconf").get("testRunner")

    --   local cmd = { vim.loop.exepath(), "--embed", "--headless", "-n", "--clean" } -- subprocess.lua
    require("neotest").setup({
      adapters = {
        testRunner == "vitest" and require("neotest-vitest") or require("neotest-jest")({
          jest_test_discovery = false,
          jestCommand = configurationJestCommand,
        }),
        require("neotest-plenary"),
      },
      quickfix = {
        enabled = false,
        open = false,
      },
      icons = {
        failed = "❌",
        passed = "✅",
        running = "R",
        skipped = "S",
        unknown = "U",
      },
      discovery = {
        enabled = false,
      },
      summary = {
        mappings = {
          attach = "a",
          clear_marked = "M",
          clear_target = "T",
          expand = { "<right>", "<left>" },
          expand_all = "<tab>",
          jumpto = { "i", "<cr>" },
          mark = "m",
          next_failed = "J",
          output = "o",
          prev_failed = "K",
          run = "r",
          debug = "d",
          run_marked = "R",
          debug_marked = "D",
          short = "O",
          stop = "s",
          target = "t",
        },
      },
    })
  end,
}
