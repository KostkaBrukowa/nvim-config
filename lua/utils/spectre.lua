local spectre_actions = safe_require("spectre.actions")

local M = {}

function M.preview_spectre_file()
  if not spectre_actions then
    return
  end

  spectre_actions.select_entry()
  --- back to previous window
  vim.cmd.normal("zz")
  vim.cmd.normal("|||")
end

return M
