local lsp_signature = safe_require("lsp_signature")
local fn = vim.fn

if not lsp_signature then
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

	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	local ASquareRight = fn.has("macunix") == 1 and "≥" or "<A->>"

	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap(bufnr, "n", ASquareRight, "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	keymap(bufnr, "n", "<leader>td", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)

	keymap(bufnr, "n", "<leader>2", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	keymap(bufnr, "n", "gh", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

	keymap(bufnr, "n", "<C-n>", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

	-- Less important
	keymap(bufnr, "n", "gk", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

	-- UNUSED
	-- Same as definition
	-- Same as definition
	--[[ keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts) ]]
	-- Only use next and cycle
	--[[ keymap(bufnr, "n", "", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts) ]]
	-- Using prettier for formatting everywhere
	--[[ keymap(bufnr, "n", "gf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts) ]]
	-- Does nothing in typescript
	--[[ keymap(bufnr, "n", "<leader>pp", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts) ]]
	-- TS does not use implementation that much
	--[[ keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) ]]
end

return M
