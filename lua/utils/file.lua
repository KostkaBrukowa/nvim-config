local lsp_config_util = require("lspconfig.util")

local M = {}

M.file_exists = function(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

M.file_exists_in_project_root = function(filename)
  local file_path = vim.api.nvim_buf_get_name(0)

  if file_path == "" or file_path == nil then
    file_path = vim.fn.getcwd()
  end

  local yarn_lock = lsp_config_util.root_pattern(filename)(file_path)

  if yarn_lock ~= nil then
    return true
  end

  return false
end

return M
