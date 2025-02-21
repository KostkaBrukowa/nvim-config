return {
  "rmagatti/auto-session",
  cond = not vim.g.vscode,
  opts = {
    log_level = "error",
    auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
    -- pre_save_cmds = { "ClosePluginOwned" },
    auto_session_use_git_branch = false,
  },
}
