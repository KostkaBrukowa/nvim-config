return {
  "nvim-neotest/neotest",
  keys = {
    "<leader>n",
  },
  dependencies = {
    "nvim-neotest/neotest-jest",
    "nvim-neotest/neotest-plenary",
  },
  opts = {
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
      concurrent = 1,
      filter_dir = function()
        return false
      end,
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
  },
  config = function(config)
    config.opts.adapters = {
      require("neotest-jest")({
        jest_test_discovery = true,
      }),
      require("neotest-plenary"),
    }

    require("neotest").setup(config.opts)
  end,
}
