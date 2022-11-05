--[[ local catppuccin = safe_require("catppuccin") ]]
--[[]]
--[[ if not catppuccin then ]]
--[[ 	return ]]
--[[ end ]]
--[[]]
--[[ vim.g.catppuccin_flavour = "mocha" ]]
--[[]]
--[[ catppuccin.setup() ]]
--[[]]
--[[ vim.cmd([[colorscheme catppuccin\]\]) ]]
--
require("tokyonight").setup({
	on_colors = function(colors)
		--[[ print(vim.inspect(colors)) ]]
		colors.bg = "#111a1a"
	end,
})

vim.o.background = "dark"

vim.cmd([[colorscheme tokyonight]])
