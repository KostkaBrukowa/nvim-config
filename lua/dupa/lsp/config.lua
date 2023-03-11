local convert_multiline_diagnostics_to_singleline = require("dupa.lsp.convert-multiline-diagnostics-to-singleline")
local signs = {
	{ name = "DiagnosticSignError", text = "" },
	{ name = "DiagnosticSignWarn", text = "" },
	{ name = "DiagnosticSignHint", text = "" },
	{ name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
	virtual_text = true,
	signs = {
		active = signs,
	},
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minmal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
}

vim.diagnostic.config(config)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	update_in_insert = false,
	severity_sort = true,
	virtual_text = {
		prefix = "  ",
	},
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
	silent = true,
})

vim.diagnostic.handlers.underline = {
	show = convert_multiline_diagnostics_to_singleline.remove_multiline_underline_handler,
	hide = vim.diagnostic.handlers.underline.hide,
}

vim.diagnostic.handlers.virtual_text = {
	show = convert_multiline_diagnostics_to_singleline.add_source_to_virtual_text_handler,
	hide = vim.diagnostic.handlers.virtual_text.hide,
}
