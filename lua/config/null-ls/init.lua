local M = {}

function M.setup()
	local status_ok, null_ls = pcall(require, "null-ls")
	if not status_ok then
		return
	end

	local default_opts = {
		capabilities = require("config.null-ls.utils").common_capabilities(),
	}

	null_ls.setup(default_opts)
	require("config.null-ls.code_actions").setup()
	require("config.null-ls.linters").setup()
	require("config.null-ls.formatters").setup()
end

return M
