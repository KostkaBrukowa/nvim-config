local mason = safe_require("mason")

if not mason then
	return
end

mason.setup()

local m = safe_require("mason-lspconfig")

if not m then
	return
end

local lspconfig = safe_require("lspconfig")

if not lspconfig then
	return
end

m.setup({
	ensure_installed = {
		"jsonls",
		"eslint",
		"html",
		"cssls",
		"yamlls",
		"marksman",
		"volar",
	},
})

require("dupa.lsp.config")

local cmp_nvim_lsp = safe_require("cmp_nvim_lsp")

if not cmp_nvim_lsp then
	return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

local on_attach = require("dupa.lsp.on_attach").on_attach

local opts = {
	capabilities = capabilities,
	on_attach = on_attach,
}

local allegro_metrum = safe_require("allegro-metrum")
if allegro_metrum then
	allegro_metrum.setup({ on_attach = on_attach })
end

m.setup_handlers({
	function(server_name)
		local has_custom_opts, custom_opts = pcall(require, "dupa.lsp.settings." .. server_name)

		if has_custom_opts then
			opts = vim.tbl_deep_extend("force", custom_opts, opts)
		end

		lspconfig[server_name].setup(opts)
	end,
})
