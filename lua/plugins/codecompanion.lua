return {
  "olimorris/codecompanion.nvim",
  enabled = false,
  cond = not vim.g.vscode,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local api_key = os.getenv("GOOGLE_API_KEY")
    require("codecompanion").setup({
      adapters = {
        acp = {
          gemini_cli = function()
            return require("codecompanion.adapters").extend("gemini_cli", {
              defaults = {
                auth_method = "gemini-api-key", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
              },
              env = {
                GEMINI_API_KEY = api_key,
              },
            })
          end,
        },
      },
      -- Add your configuration here
      -- For example, you can configure adapters, display options, etc.
      -- See https://codecompanion.olimorris.dev/configuration/ for full options
    })
  end,
}
