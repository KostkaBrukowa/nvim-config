local navic = require("nvim-navic")
local M = {}

M.on_attach = function(client, bufnr)
  client.server_capabilities.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  if client.name == "tsserver" then
    client.server_capabilities.document_formatting = false
  end

  if client.name == "html" then
    client.server_capabilities.document_formatting = false
  end

  if client.name == "sumneko_lua" then
    client.server_capabilities.document_formatting = false
  end

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

return M
