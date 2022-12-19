local function configure()
	local dap_breakpoint = {
		breakpoint = {
			text = "",
			texthl = "LspDiagnosticsSignError",
			linehl = "",
			numhl = "",
		},
		rejected = {
			text = "",
			texthl = "LspDiagnosticsSignHint",
			linehl = "",
			numhl = "",
		},
		stopped = {
			text = "=>",
			texthl = "LspDiagnosticsSignInformation",
			linehl = "DiagnosticUnderlineInfo",
			numhl = "LspDiagnosticsSignInformation",
		},
	}

	vim.fn.sign_define("DapBreakpoint", dap_breakpoint.breakpoint)
	vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
	vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

	local set_hl = vim.api.nvim_set_hl

	set_hl(0, "LspDiagnosticsSignError", { fg = "#ff0000" })
	-- 'Diagnostic' .. severities[diagnostic.severity] or severities[1]
end

local function configure_exts()
	require("nvim-dap-virtual-text").setup({
		commented = true,
	})

	local dap, dapui = require("dap"), require("dapui")
	dapui.setup({
		mappings = {
			-- Use a table to apply multiple mappings
			expand = { "<CR>", "<2-LeftMouse>" },
			open = "o",
			remove = "d",
			edit = "c", -- configure
			repl = "r",
			toggle = "t",
		},
		layouts = {
			{
				elements = {
					-- Elements can be strings or table with id and size keys.
					{ id = "scopes", size = 0.4 },
					{ id = "watches", size = 0.4 },
					{ id = "breakpoints", size = 0.1 },
					{ id = "stacks", size = 0.1 },
				},
				size = 40, -- 40 columns
				position = "left",
			},
			{
				elements = {
					"repl",
					"console",
				},
				size = 0.25, -- 25% of total lines
				position = "bottom",
			},
		},
	}) -- use default
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	--[[ dap.listeners.before.event_terminated["dapui_config"] = function() ]]
	--[[ 	dapui.close() ]]
	--[[ end ]]
	--[[ dap.listeners.before.event_exited["dapui_config"] = function() ]]
	--[[ 	dapui.close() ]]
	--[[ end ]]
end

local function configure_debuggers()
	require("config.dap.javascript")
	require("config.dap.lua")
	-- require("config.dap.keymaps").setup() -- Done it hydra-dap
end

configure() -- Configuration
configure_exts() -- Extensions
configure_debuggers() -- Debugger
-- require("config.dap.keymaps").setup() -- Keymaps
