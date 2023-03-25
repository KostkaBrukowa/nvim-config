local convert_multiline_diagnostics_to_singleline = require("dupa.lsp.convert-multiline-diagnostics-to-singleline")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	update_in_insert = false,
	severity_sort = true,
	signs = false,
	virtual_text = {
		prefix = "  ",
	},
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	silent = true,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {})

vim.diagnostic.handlers.underline = {
	show = convert_multiline_diagnostics_to_singleline.remove_multiline_underline_handler,
	hide = vim.diagnostic.handlers.underline.hide,
}

vim.diagnostic.handlers.virtual_text = {
	show = convert_multiline_diagnostics_to_singleline.add_source_to_virtual_text_handler,
	hide = vim.diagnostic.handlers.virtual_text.hide,
}
