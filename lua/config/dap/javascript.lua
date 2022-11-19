for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
	require("dap").configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "[pwa-node] Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "[pwa-node] Attach",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Debug Jest Tests",
			-- trace = true, -- include debugger info
			runtimeExecutable = "node",
			runtimeArgs = {
				"./node_modules/jest/bin/jest.js",
				"--runInBand",
			},
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
		},
	}
end

local js_debug = safe_require("dap-vscode-js")

if not js_debug then
	return
end

js_debug.setup({
	debugger_path = "/Users/jaroslaw.glegola/.local/share/nvim/site/pack/packer/start/vscode-js-debug/", -- Path to vscode-js-debug installation.
	adapters = { "pwa-node", "pwa-chrome", "node-terminal" }, -- which adapters to register in nvim-dap
})

-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
-- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
--[[ adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap ]]
-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
