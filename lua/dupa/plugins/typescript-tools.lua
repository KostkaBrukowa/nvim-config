return {
  "pmizio/typescript-tools.nvim",
  ft = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  enabled = true,
  opts = {
    settings = {
      -- tsserver_logs = "verbose",
      expose_as_code_action = {},
      tsserver_plugins = { "@styled/typescript-styled-plugin" },
      separate_diagnostic_server = true,
      publish_diagnostic_on = "insert_leave",
      -- experimentals = { workspace_diagnostic = true },
      tsserver_file_preferences = {
        includeInlayParameterNameHints = "none",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = false,
        includeInlayVariableTypeHints = false,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = false,
        includeInlayFunctionLikeReturnTypeHints = false,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
}
