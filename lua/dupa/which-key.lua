local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = "n", keys = "<Leader>" },
    { mode = "v", keys = "<Leader>" },
  },
  clues = {
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
    { mode = "n", keys = "<leader>r", desc = "Find and replace" },
    { mode = "n", keys = "<leader>u", desc = "Utils" },
    { mode = "y", keys = "<leader>u", desc = "Utils" },
  },
})
