-- Copilot
vim.cmd([[
  imap <silent><script><expr> <Right> copilot#Accept("\<Right>")
  let g:copilot_no_tab_map = v:true
]])

vim.g.copilot_filetypes = { ["dap-repl"] = false, ["dapui_watches"] = false }
