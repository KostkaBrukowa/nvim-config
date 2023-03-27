local set_hl = vim.api.nvim_set_hl
require("tokyonight").setup({
	styles = {
		floats = "transparent",
	},

	dim_inactive = true,
	on_colors = function(colors)
		colors.hint = colors.dark5
	end,
})

vim.o.background = "dark"
vim.cmd([[colorscheme tokyonight-moon]])
--vim.cmd([[colorscheme catppuccin]])
-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#121212" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#121212" })
-- vim.api.nvim_set_hl(0, "CmpPmenu", { bg = "#121212" })
