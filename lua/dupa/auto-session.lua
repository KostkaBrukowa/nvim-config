local session = require("auto-session")

session.setup({
  log_level = "error",
  auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
  -- pre_save_cmds = { "ClosePluginOwned" },
  auto_session_use_git_branch = false,
})
