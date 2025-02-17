return {
  "echasnovski/mini.clue",
  event = "VeryLazy",
  config = function()
    local miniclue = require("mini.clue")
    miniclue.setup({
      triggers = {
        -- Leader triggers
        { mode = "n", keys = "<leader>c" },
        { mode = "n", keys = "<leader>ur" },
        { mode = "n", keys = "<leader>d" },
        { mode = "n", keys = "<leader>f" },
        { mode = "n", keys = "<leader>g" },
        { mode = "n", keys = "<leader>i" },
        { mode = "n", keys = "<leader>n" },
        { mode = "n", keys = "<leader>o" },
        { mode = "n", keys = "<leader>t" },
        { mode = "n", keys = "<leader>u" },
        { mode = "n", keys = "<leader>uf" },
        { mode = "n", keys = "<leader>ul" },
        { mode = "n", keys = "<leader>up" },
        { mode = "n", keys = "<leader>g" },
        { mode = "n", keys = "<leader>u" },
        { mode = "v", keys = "<leader>u" },
        { mode = "n", keys = "<c-w>" },
      },
      clues = {
        -- ...existing clues configuration...
        { mode = "n", keys = "<leader>c", desc = "Changes in project" },
        { mode = "n", keys = "<leader>ur", desc = "Find and replace" },
        { mode = "n", keys = "<leader>d", desc = "Diff View" },
        { mode = "n", keys = "<leader>f", desc = "Find" },
        { mode = "n", keys = "<leader>g", desc = "Git" },
        { mode = "n", keys = "<leader>i", desc = "TSTools" },
        { mode = "n", keys = "<leader>n", desc = "Neotest" },
        { mode = "n", keys = "<leader>o", desc = "Other files" },
        { mode = "n", keys = "<leader>t", desc = "File Explorer" },
        { mode = "n", keys = "<leader>u", desc = "Utils" },
        { mode = "n", keys = "<leader>uf", desc = "Find" },
        { mode = "n", keys = "<leader>ul", desc = "LSP" },
        { mode = "n", keys = "<leader>up", desc = "Package json actions" },
        { mode = "n", keys = "<leader>g", desc = "Git" },
        { mode = "n", keys = "<leader>u", desc = "Utils" },
        { mode = "y", keys = "<leader>u", desc = "Utils" },
      },
    })
  end,
}
