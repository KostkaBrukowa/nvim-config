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

vim.o.background = "dark" -- or "light" for light mode

vim.cmd([[colorscheme gruvbox]])
