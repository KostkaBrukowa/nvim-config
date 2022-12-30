require("lab").setup()
require("leap").setup({})
require("scrollbar").setup()
require("substitute").setup({})
require("nvim-surround").setup()

-- require("refactoring").setup({})

require("printer").setup({
	keymap = "gp", -- Plugin doesn't have any keymaps by default
})

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

-- Copilot
vim.cmd([[
  imap <silent><script><expr> <Right> copilot#Accept("\<Right>")
  let g:copilot_no_tab_map = v:true
]])
vim.g.copilot_filetypes = { ["dap-repl"] = false, ["dapui_watches"] = false }

-- profiling
local function toggle_profile()
	local prof = require("profile")
	if prof.is_recording() then
		prof.stop()
		vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
			if filename then
				prof.export(filename)
				vim.notify(string.format("Wrote %s", filename))
			end
		end)
	else
		prof.start("*")
	end
end

require("package-info").setup({})
vim.keymap.set("", "<leader><leader>x", toggle_profile)
