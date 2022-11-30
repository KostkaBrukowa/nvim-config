require("lab").setup()
require("fidget").setup({})
require("messages").setup()
-- require("indent_blankline").setup() -- Test if I need it
require("leap").setup({})
require("scrollbar").setup()
require("substitute").setup({})
require("tabout").setup({})

require("notify").setup({
	stages = "fade",
	timeout = 3000,
})
require("windows").setup({
	autowidth = { --		       |windows.autowidth|
		enable = false,
	},
})
require("smoothcursor").setup({
	speed = 25, -- max is 100 to stick to your current position
	intervals = 35, -- tick interval
})
