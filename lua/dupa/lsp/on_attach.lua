local lsp_signature = safe_require("lsp_signature")
local lsp_inlayhints = safe_require("lsp-inlayhints")

if not lsp_signature or not lsp_inlayhints then
	return
end

local M = {}

M.on_attach = function(client, bufnr)
	lsp_signature.on_attach({
		floating_window = false,
	}, bufnr)

	if client.name == "tsserver" then
		client.server_capabilities.document_formatting = false
	end

	if client.name == "sumneko_lua" then
		client.server_capabilities.document_formatting = false
	end

	--[[ keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts) ]]

	-- Semantic Tokens
	local caps = client.server_capabilities
	if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
		local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
		vim.api.nvim_create_autocmd("TextChanged", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.semantic_tokens_full()
			end,
		})
		-- fire it first time on load as well
		vim.lsp.buf.semantic_tokens_full()
	end

	-- Inlay hints maybe in the future
	--[[ lsp_inlayhints.setup({}) ]]
	--[[ lsp_inlayhints.on_attach(client, bufnr) ]]
end

return M
