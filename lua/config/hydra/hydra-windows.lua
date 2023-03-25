local Hydra = require("hydra")
local splits = require("smart-splits")

local cmd = require("hydra.keymap-util").cmd
local pcmd = require("hydra.keymap-util").pcmd

-- vim.keymap.set("n", "gb", choose_buffer)

local window_hint = [[
 ^^^^^^^^^^^^     Move      ^^    Size   ^^   ^^     Split
 ^^^^^^^^^^^^-------------  ^^-----------^^   ^^---------------
 ^ ^ _e_ ^ ^  ^ ^ _E_ ^ ^   ^   _<C-e>_   ^   _s_: horizontally 
 _h_ ^ ^ _i_  _H_ ^ ^ _I_   _<C-h>_ _<C-i>_   _v_: vertically
 ^ ^ _n_ ^ ^  ^ ^ _N_ ^ ^   ^   _<C-n>_   ^   _q_, _x_: close
 focus^^^^^^  window^^^^^^  ^_=_: equalize^   _m_: maximize
 ^ ^ ^ ^ ^ ^  ^ ^ ^ ^ ^ ^   ^^ ^          ^   _o_: remain only
]]

Hydra({
	name = "Windows",
	hint = window_hint,
	config = {
		invoke_on_body = true,
		hint = {
			offset = -1,
		},
	},
	mode = "n",
	body = "<C-w>",
	heads = {
		{ "h", "<C-w>h" },
		{ "n", "<C-w>j" },
		{ "e", pcmd("wincmd k", "E11", "close") },
		{ "i", "<C-w>l" },

		{ "H", cmd("WinShift left") },
		{ "N", cmd("WinShift down") },
		{ "E", cmd("WinShift up") },
		{ "I", cmd("WinShift right") },

		{
			"<C-h>",
			function()
				splits.resize_left(2)
			end,
		},
		{
			"<C-n>",
			function()
				splits.resize_down(2)
			end,
		},
		{
			"<C-e>",
			function()
				splits.resize_up(2)
			end,
		},
		{
			"<C-i>",
			function()
				splits.resize_right(2)
			end,
		},
		{ "=", "<C-w>=", { desc = "equalize" } },

		{ "s", pcmd("split", "E36") },
		{ "<C-s>", pcmd("split", "E36"), { desc = false } },
		{ "v", pcmd("vsplit", "E36") },
		{ "<C-v>", pcmd("vsplit", "E36"), { desc = false } },

		{ "w", "<C-w>w", { exit = true, desc = false } },
		{ "<C-w>", "<C-w>w", { exit = true, desc = false } },

		{ "m", cmd("WindowsMaximize"), { exit = true, desc = "maximize" } },
		{ "<C-z>", cmd("WindowsMaximize"), { exit = true, desc = false } },

		{ "o", "<C-w>o", { exit = true, desc = "remain only" } },
		{ "<C-o>", "<C-w>o", { exit = true, desc = false } },

		-- { "b", choose_buffer, { exit = true, desc = "choose buffer" } },

		{ "x", pcmd("close", "E444") },
		{ "q", pcmd("close", "E444"), { desc = "close window" } },
		{ "<C-c>", pcmd("close", "E444"), { desc = false } },
		{ "<C-q>", pcmd("close", "E444"), { desc = false } },

		{ "<Esc>", nil, { exit = true, desc = false } },
	},
})
