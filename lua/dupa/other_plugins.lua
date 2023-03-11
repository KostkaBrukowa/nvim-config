require("lab").setup()
require("leap").setup({})
require("messages").setup()
require("substitute").setup({})
require("nvim-surround").setup()

-- require("refactoring").setup({})

require("printer").setup({
	keymap = "<leader>l", -- Plugin doesn't have any keymaps by default
	formatters = {
		typescriptreact = function(inside, variable)
			return string.format('console.log("%s: ",  %s)', inside, variable)
		end,
		lua = function(text_inside, text_var)
			return string.format("print([[%s: ]] .. vim.inspect(%s))", text_inside, text_var)
		end,
	},
	add_to_inside = function(text)
		local splitFilename = vim.split(vim.fn.expand("%"), "/")
		return string.format("[%s:%s] -- %s", splitFilename[#splitFilename], vim.fn.line("."), text)
	end,
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
require("lsp-file-operations").setup({
	debug = false,
})

require("local-highlight").setup({})

require("eyeliner").setup({})

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
