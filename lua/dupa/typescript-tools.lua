local ok, tst = pcall(require, "typescript-tools")

if not ok then
  return
end

tst.setup({
  settings = {
    -- tsserver_logs = "verbose",
    -- tsserver_plugins = { "@styled/typescript-styled-plugin" },
    separate_diagnostic_server = true,
    publish_diagnostic_on = "insert_leave",
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
})
