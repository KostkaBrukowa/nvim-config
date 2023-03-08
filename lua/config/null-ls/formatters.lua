local M = {}

local util = require("lspconfig.util")
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
	local configs = {}
	if M.has_prettier_config() then
		configs[#configs + 1] = {
			command = "prettierd",
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "css", "postcss", "html" },
		}
	end
	configs[#configs + 1] = {
		command = "eslint_d",
	}
	configs[#configs + 1] = {
		command = "stylua",
	}

	M.setup_formatter(configs)
end

local PACKAGE_JSON = "package.json"

local PRETTIER_CONFIG = {
	".prettierrc.json",
	".prettierrc",
	"prettier.config.js",
	".prettierrc.js",
	".prettierrc.yml",
	".prettierrc.yaml",
	".prettierrc.json5",
	".prettierrc.cjs",
	"prettier.config.cjs",
	".prettierrc.toml",
}

function M.has_prettier_config()
	local file_path = vim.api.nvim_buf_get_name(0)

	if file_path == "" or file_path == nil then
		file_path = vim.fn.getcwd()
	end

	local package_json = util.root_pattern(PACKAGE_JSON)(file_path)
	-- vim.notify(vim.inspect(package_json))
	if package_json ~= nil then
		local content = table.concat(vim.fn.readfile(package_json .. "/" .. PACKAGE_JSON, "\n"))
		local err, json_content = pcall(vim.json.decode, content)

		if err and json_content.prettier ~= nil then
			vim.notify("has prettier")
			return true
		end
	end

	for _, c in pairs(PRETTIER_CONFIG) do
		if util.root_pattern(c)(file_path) ~= nil then
			vim.notify(vim.inspect(c))
			vim.notify(vim.inspect(file_path))
			return true
		end
	end

	return false
end

return M
