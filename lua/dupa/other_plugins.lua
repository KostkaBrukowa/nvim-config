require("lab").setup()
require("messages").setup()
-- require("indent_blankline").setup() -- Test if I need it
require("leap").setup({})
require("scrollbar").setup()
require("substitute").setup({})
require("tabout").setup({})
require("nvim-surround").setup()

-- require("refactoring").setup({})

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
require("fidget").setup({
	sources = { -- Sources to configure
		["null-ls"] = { -- Name of source
			ignore = true, -- Ignore notifications from this source
		},
		hls = { -- Name of source
			ignore = true, -- Ignore notifications from this source
		},
	},
})

-- Copilot
vim.cmd([[
  imap <silent><script><expr> <Right> copilot#Accept("\<Right>")
  let g:copilot_no_tab_map = v:true
]])
vim.g.copilot_filetypes = { ["dap-repl"] = false, ["dapui_watches"] = false }
