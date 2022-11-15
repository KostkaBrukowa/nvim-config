local neotest = safe_require("neotest")

if not neotest then
	return
end

require("neotest").setup({
	adapters = {
		require("neotest-jest"),
		require("neotest-vim-test")({
			ignore_file_types = { "python", "vim", "lua" },
		}),
	},
	icons = {
		failed = "F",
		passed = "✅",
		running = "R",
		skipped = "S",
		unknown = "U",
	},
	mappings = {
		attach = "a",
		clear_marked = "M",
		clear_target = "T",
		expand = { "<CR>", "<2-LeftMouse>" },
		expand_all = "e",
		jumpto = "i",
		mark = "m",
		next_failed = "J",
		output = "o",
		prev_failed = "K",
		run = "r",
		debug = "d",
		run_marked = "R",
		debug_marked = "D",
		short = "O",
		stop = "u",
		target = "t",
	},
})
