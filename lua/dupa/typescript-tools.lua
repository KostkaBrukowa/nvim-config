local ok, tst = pcall(require, "typescript-tools")

if not ok then
  return
end

tst.setup({
  on_attach = function(client)
    client.server_capabilities.semanticTokensProvider = false
  end,
  settings = {
    -- tsserver_logs = "verbose",
    -- tsserver_logs = {
    --   verbosity = "verbose",
    --   file_basename = "/Users/jaroslaw.glegola/.config/nvim/tsserver.log",
    -- },
    -- tsserver_plugins = { "@styled/typescript-styled-plugin" },
    separate_diagnostic_server = true,
    publish_diagnostic_on = "insert_leave",
  },
})
