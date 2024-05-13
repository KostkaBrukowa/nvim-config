local ok, tst = pcall(require, "typescript-tools")

if not ok then
  return
end

tst.setup({
  settings = {
    -- tsserver_logs = "verbose",
    -- tsserver_logs = {
    --   verbosity = "verbose",
    --   file_basename = "/Users/jaroslaw.glegola/.config/nvim/tsserver.log",
    -- },
    tsserver_plugins = { "typescript-plugin-css-modules" },
    separate_diagnostic_server = true,
    publish_diagnostic_on = "insert_leave",
    -- code_lens = "all",
    -- disable_member_code_lens = true,
  },
})
