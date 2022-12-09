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
		"haskell",
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
})

vim.cmd([[hi rainbowcol1 guifg=#7f849c]])
