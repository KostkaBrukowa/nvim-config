return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "Pocco81/dap-buddy.nvim",
    "theHamsta/nvim-dap-virtual-text",
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    {
      "microsoft/vscode-js-debug",
      build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    },
    "mxsdev/nvim-dap-vscode-js",
    "jbyuki/one-small-step-for-vimkind",
  },
  config = function()
    -- Configuration function
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

    -- Extensions configuration
    require("nvim-dap-virtual-text").setup({
      commented = true,
    })

    local dap, dapui = require("dap"), require("dapui")
    dapui.setup({
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "c",
        repl = "r",
        toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.4 },
            { id = "watches", size = 0.4 },
            { id = "breakpoints", size = 0.1 },
            { id = "stacks", size = 0.1 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 0.25,
          position = "bottom",
        },
      },
    })

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end

    -- Debugger configurations
    require("config.dap.javascript")
    require("config.dap.lua")
    require("config.dap.csharp")
  end,
}
