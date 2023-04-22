local auto_save = safe_require("auto-save")

if not auto_save then
  return
end

auto_save.setup({
  trigger_events = { "FocusLost", "BufLeave" }, -- vim events that trigger auto-save. See :h events
  condition = function(buf)
    local fn = vim.fn
    local code_action_buf_exists = vim.tbl_filter(function(bufnr)
      return vim.api.nvim_buf_get_option(bufnr, "filetype"):find("sagacodeaction")
    end, vim.api.nvim_list_bufs())[1]

    if fn.getbufvar(buf, "&modifiable") == 1 and not code_action_buf_exists then
      return true -- met condition(s), can save
    end
    return false -- can't save
  end,
})
