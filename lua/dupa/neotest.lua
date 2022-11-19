local neotest = safe_require("neotest")

if not neotest then
	return
end

require("neotest").setup({
	adapters = {
		require("neotest-jest"),
	},
	icons = {
		failed = "❌",
		passed = "✅",
		running = "R",
		skipped = "S",
		unknown = "U",
	},
	summary = {
		mappings = {
			attach = "a",
			clear_marked = "M",
			clear_target = "T",
			expand = { "<right>", "<left>" },
			expand_all = "<tab>",
			jumpto = { "i", "<cr>" },
			mark = "m",
			next_failed = "J",
			output = "o",
			prev_failed = "K",
			run = "r",
			debug = "d",
			run_marked = "R",
			debug_marked = "D",
			short = "O",
			stop = "s",
			target = "t",
		},
	},
})
