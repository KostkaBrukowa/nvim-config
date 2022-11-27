local M = {}

function M.common_capabilities()
  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    return cmp_nvim_lsp.default_capabilities()
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }

  return capabilities
end

function M.format_filter(client)
  local filetype = vim.bo.filetype
  local n = require("null-ls")
  local s = require("null-ls.sources")
  local method = n.methods.FORMATTING
  local available_formatters = s.get_available(filetype, method)
  -- print(vim.inspect(available_formatters))

  if #available_formatters > 0 then
    return client.name == "null-ls"
  elseif client.supports_method("textDocument/formatting") then
    return true
  else
    return false
  end
end

function M.enable_format_on_save()
  vim.api.nvim_create_augroup("lsp_format_on_save", {})
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = "lsp_format_on_save",
    pattern = "*",
    callback = function()
      vim.lsp.buf.format({ timeout_ms = 5000, filter = M.format_filter })
    end,
  })
end

return M
