local M = {}
local globalAuGroup = vim.api.nvim_create_augroup("GlobalAuGroup", { clear = true })

function M.create_onetime_autocmd(event, opts)
  vim.api.nvim_create_autocmd(event, vim.tbl_extend("force", opts, { group = globalAuGroup }))
end

return M
