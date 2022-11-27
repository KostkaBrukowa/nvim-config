local M = {}

local null_ls = require("null-ls")
local services = require("config.null-ls.services")
local method = null_ls.methods.CODE_ACTION

function M.setup_code_actions(actions_configs)
  if vim.tbl_isempty(actions_configs) then
    return
  end

  services.register_sources(actions_configs, method)
end

function M.setup() end

return M
