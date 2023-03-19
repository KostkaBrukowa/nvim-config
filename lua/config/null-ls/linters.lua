local M = {}

local null_ls = require("null-ls")
local services = require("config.null-ls.services")
local method = null_ls.methods.DIAGNOSTICS
local util = require("lspconfig.util")

function M.setup_linters(linter_configs)
	if vim.tbl_isempty(linter_configs) then
		return
	end

	services.register_sources(linter_configs, method)
end

function M.setup()
	local configs = {}

	if M.has_luarc() then
		configs[#configs + 1] = {
			command = "luacheck",
		}
	end

	M.setup_linters(configs)
end

function M.has_luarc()
	local file_path = vim.api.nvim_buf_get_name(0)

	if file_path == "" or file_path == nil then
		file_path = vim.fn.getcwd()
	end

	local package_json = util.root_pattern(".luacheckrc")(file_path)

	if package_json ~= nil then
		return true
	end

	return false
end

return M
