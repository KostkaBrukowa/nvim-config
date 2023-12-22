local session = require("auto-session")

-- Detect if window is owned by plugin by checking buftype.
local is_plugin_owned = function(bufid)
  local origin_type = vim.api.nvim_buf_get_option(bufid, "buftype")

  if origin_type == "" or origin_type == "help" then
    return false
  end

  return true
end

local close_plugin_owned = function()
  -- Jump to preview window if current window is plugin owned.
  if is_plugin_owned(0) then
    vim.cmd([[ wincmd p ]])
  end

  for _, win in ipairs(vim.fn.getwininfo()) do
    if is_plugin_owned(win.bufnr) then
      -- Delete plugin owned window buffers.
      vim.api.nvim_buf_delete(win.bufnr, {})
    end
  end
end

vim.api.nvim_create_user_command("ClosePluginOwned", function(e)
  close_plugin_owned()
end, { nargs = "*" })

session.setup({
  log_level = "error",
  auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
  -- pre_save_cmds = { "ClosePluginOwned" },
  auto_session_use_git_branch = false,
})
