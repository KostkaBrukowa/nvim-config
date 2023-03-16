local M = {}

local null_ls = require("null-ls")
local services = require("config.null-ls.services")
local method = null_ls.methods.DIAGNOSTICS

function M.setup_linters(linter_configs)
	if vim.tbl_isempty(linter_configs) then
		return
	end

	services.register_sources(linter_configs, method)
end

function M.setup()
	local configs = {}

	configs[#configs + 1] = {
		command = "luacheck",
	}

	M.setup_linters(configs)
end

return M
