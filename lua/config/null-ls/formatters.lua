local M = {}

local null_ls = require("null-ls")
local services = require("config.null-ls.services")
local method = null_ls.methods.FORMATTING

function M.setup_formatter(formatter_configs)
	if vim.tbl_isempty(formatter_configs) then
		return
	end

	services.register_sources(formatter_configs, method)
end

function M.setup()
	M.setup_formatter({
		{
			command = "prettierd",
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		},
		{
			command = "eslint_d",
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		},
		{
			command = "stylua",
		},
	})
end

return M
