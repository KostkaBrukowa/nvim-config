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

local find_git_ancestor = require("lspconfig.util").find_git_ancestor
local find_package_json_ancestor = require("lspconfig.util").find_package_json_ancestor
local path_join = require("lspconfig.util").path.join

local function get_working_directory()
  local startpath = vim.fn.getcwd()
  return find_git_ancestor(startpath) or find_package_json_ancestor(startpath)
end

---@param opts? { check_package_json?: boolean, config_names: string[] }
---@return boolean
function M.config_exists(opts)
  local project_root = get_working_directory()
  if not project_root then
    return false
  end

  opts = opts or {}

  local exists = false

  for _, config_name in ipairs(opts.config_names) do
    exists = exists or vim.tbl_count(vim.fn.glob(config_name, true, true)) > 0
  end

  if not exists and opts.check_package_json then
    local ok, has_prettier_key = pcall(function()
      local package_json_blob =
        table.concat(vim.fn.readfile(path_join(project_root, "/package.json")))
      local package_json = vim.json.decode(package_json_blob)
      return not not package_json["prettier"]
    end)

    exists = ok and has_prettier_key
  end

  return exists
end

return M
