local lspconfig = require("lspconfig")
local lsp_format = require("lsp-format")
local null_ls = require("null-ls")
local mason_lspconfig = require("mason-lspconfig")
local prettier_utils = require("trash.lsp.prettier-config")

local JS_TS_SETTINGS = {
	tab_width = 2,
	order = { "eslint", "null-ls" },
	-- disable prettier formatting when prettier is not present @ project
	exclude = prettier_utils.has_prettier_config() and {} or { "null-ls" },
}

for _, server_name in pairs(mason_lspconfig.get_installed_servers()) do
	print(server_name)
	if server_name == "eslint" then
		lspconfig[server_name].setup(vim.tbl_extend("force", {
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = true
				client.server_capabilities.renameProvider = false
				require("lsp-format").on_attach(client)
			end,
		}, {}))
	end
end

lsp_format.setup({
	typescript = JS_TS_SETTINGS,
	typescriptreact = JS_TS_SETTINGS,
	javascript = JS_TS_SETTINGS,
	javascriptreact = JS_TS_SETTINGS,
	lua = { tab_width = 2 },
	rust = { tab_width = 4 },
	go = { tab_width = 4 },
})

null_ls.setup({
	on_attach = lsp_format.on_attach,
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettierd,
	},
})
