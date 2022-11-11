local treesitter = safe_require("nvim-treesitter.configs")

if not treesitter then
	return
end

treesitter.setup({
	ensure_installed = {
		"lua",
		"markdown",
		"html",
		"css",
		"javascript",
		"typescript",
		"tsx",
		"prisma",
		"json",
		"svelte",
		"scss",
		"c",
		"python",
		"pug",
		"php",
		"java",
		"astro",
		"vue",
		"dockerfile",
		"graphql",
		"yaml",
		"toml",
	},
	highlight = {
		enable = true,
	},
	rainbow = {
		enable = true,
		extended_mode = false,
	},
	autotag = {
		enable = true,
	},
	indent = { enable = true },
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
			},
			include_surrounding_whitespace = true,
		},
		swap = {
			enable = true,
		},
		move = {
			enable = true,
		},
	},
})

vim.cmd([[hi rainbowcol1 guifg=#7f849c]])

local set_hl = vim.api.nvim_set_hl
--[[ set_hl(0, "LspType", { link = "TSType" }) ]]

require("nvim-semantic-tokens").setup({
	preset = "default",
	-- highlighters is a list of modules following the interface of nvim-semantic-tokens.table-highlighter or
	-- function with the signature: highlight_token(ctx, token, highlight) where
	--        ctx (as defined in :h lsp-handler)
	--        token  (as defined in :h vim.lsp.semantic_tokens.on_full())
	--        highlight (a helper function that you can call (also multiple times) with the determined highlight group(s) as the only parameter)
	highlighters = { require("nvim-semantic-tokens.table-highlighter") },
})
