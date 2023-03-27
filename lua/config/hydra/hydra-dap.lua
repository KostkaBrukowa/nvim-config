local Hydra = require("hydra")
local cmd = require("hydra.keymap-util").cmd

local hint = [[
 _o_:  Step over       _t_:  Toggle Breakpoint           _s_: Start                _E_: Eval expression input
 _i_:  Step into       _C_: Conditional breakpoint        _p_: Pause                _e_: Evaluate
 _u_:  Step out        ^ ^                                _d_: Disconnect           _h_: Hover variable
 _c_: 淪Continue        ^ ^                                _x_: Terminate            _S_: Scopes   
 _b_:  Step back       ^ ^                                _r_: Toggle Repl      
 _R_: Run to cursor                            
 
                                  _q_: exit             _U_: Toggle UI 
]]

Hydra({
	name = "Dap",
	hint = hint,
	config = {
		invoke_on_body = true,
		color = "pink",
		hint = {
			border = "rounded",
			offset = -1,
		},
	},
	mode = "n",
	body = "<space>b",
	heads = {
		{ "E", "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>", { silent = true } },
		{ "e", "<cmd>lua require'dapui'.eval()<cr>", { silent = true } },
		{ "h", "<cmd>lua require'dap.ui.widgets'.hover()<cr>", { silent = true } },
		{ "S", "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", { silent = true } },

		{ "t", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", { silent = true } },
		{ "C", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", { silent = true } },

		{ "s", "<cmd>lua require'dap'.continue()<cr>", { silent = true } },
		{ "U", "<cmd>lua require'dapui'.toggle()<cr>", { silent = true } },
		{ "p", "<cmd>lua require'dap'.pause.toggle()<cr>", { silent = true } },
		{ "d", "<cmd>lua require'dap'.disconnect()<cr>", { silent = true } },
		{ "x", "<cmd>lua require'dap'.terminate()<cr>", { silent = true } },
		{ "r", "<cmd>lua require'dap'.repl.toggle()<cr>", { silent = true } },

		{ "b", "<cmd>lua require'dap'.step_back()<cr>", { silent = true } },
		{ "i", "<cmd>lua require'dap'.step_into()<cr>", { silent = true } },
		{ "o", "<cmd>lua require'dap'.step_over()<cr>", { silent = true } },
		{ "u", "<cmd>lua require'dap'.step_out()<cr>", { silent = true } },
		{ "c", "<cmd>lua require'dap'.continue()<cr>", { silent = true } },
		{ "R", "<cmd>lua require'dap'.run_to_cursor()<cr>", { silent = true } },

		{ "q", nil, { exit = true, nowait = true } },
		{ "<esc>", nil, { exit = true, nowait = true, desc = false } },
	},
})
