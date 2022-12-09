local lsp_signature = safe_require("lsp_signature")

if not lsp_signature then
	return
end

local M = {}

M.on_attach = function(client, bufnr)
	lsp_signature.on_attach({
		floating_window = false,
	}, bufnr)

	client.server_capabilities.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	if client.name == "tsserver" then
		client.server_capabilities.document_formatting = false
	end

	if client.name == "sumneko_lua" then
		client.server_capabilities.document_formatting = false
	end
end

return M
