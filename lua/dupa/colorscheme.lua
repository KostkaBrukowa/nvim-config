local set_hl = vim.api.nvim_set_hl
require("tokyonight").setup({
	on_colors = function(colors)
		colors.hint = colors.dark5
	end,
})

vim.o.background = "dark"
vim.cmd([[colorscheme tokyonight-moon]])
--vim.cmd([[colorscheme catppuccin]])
