local M = {}

function M.setup()
	local status_ok, null_ls = pcall(require, "null-ls")
	if not status_ok then
		return
	end

	local default_opts = {
		capabilities = require("config.null-ls.utils").common_capabilities(),
		sources = {
			-- null_ls.builtins.diagnostics.cspell.with({
			-- 	diagnostic_config = {
			-- 		underline = true,
			-- 		virtual_text = false,
			-- 		signs = false,
			-- 		update_in_insert = false,
			-- 		severity_sort = false,
			-- 	},
			-- 	disabled_filetypes = { "NvimTree" },
			-- 	diagnostics_postprocess = function(diagnostic)
			-- 		diagnostic.severity = vim.diagnostic.severity["HINT"]
			-- 	end,
			-- }),
			-- null_ls.builtins.code_actions.cspell,
		},
	}

	null_ls.setup(default_opts)
	require("config.null-ls.code_actions").setup()
	require("config.null-ls.linters").setup()
	require("config.null-ls.formatters").setup()
end

return M
