local comment = require("Comment")

comment.setup({
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})

vim.keymap.set("n", "<leader>/", function()
  return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)j"
    or "<Plug>(comment_toggle_linewise_count)"
end, { expr = true })

vim.keymap.set("v", "<leader>/", function()
  return "<Plug>(comment_toggle_linewise_visual)"
end, { expr = true })


