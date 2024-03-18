require("diagflow").setup({
  scope = "line",
  placement = "inline",
  toggle_event = { "InsertEnter", "InsertLeave" }, -- if InsertEnter, can toggle the diagnostics on inserts
  update_event = { "CursorHold", "DiagnosticChanged", "BufReadPost" },
  format = function(diagnostic)
    return diagnostic.source and diagnostic.source .. ": " .. diagnostic.message
      or diagnostic.message
  end,
})
