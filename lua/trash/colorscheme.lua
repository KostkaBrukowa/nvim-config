require("tokyonight").setup({
	on_colors = function(colors)
		--[[ print(vim.inspect(colors)) ]]
		colors.bg = "#111a1a"
	end,
})

vim.o.background = "dark"

vim.cmd([[colorscheme tokyonight]])
