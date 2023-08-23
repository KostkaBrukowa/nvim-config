for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
  local launchFileConfig = {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "node_modules/**" },
  }
  if language == "typescript" or language == "typescriptreact" then
    launchFileConfig.runtimeArgs = {
      "--loader",
      "ts-node/esm",
    }
  end
  require("dap").configurations[language] = {
    launchFileConfig,
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
