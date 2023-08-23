local cmp = require("cmp")
local ASquareRight = vim.fn.has("macunix") == 1 and "≥" or "<A->>"

local definition_or_references = require("definition-or-references").definition_or_references

local function goto_next_diagnostic()
  for _, severity in ipairs(vim.diagnostic.severity) do
    local diagnostics = vim.diagnostic.get(0, { severity = severity })
    if #diagnostics > 0 then
      vim.diagnostic.goto_next({
        severity = severity,
        float = { border = "rounded", source = true },
      })
      return
    end
  end
end

local function open_float()
  vim.diagnostic.open_float({ border = "rounded", source = true })
end

vim.keymap.set({ "n", "v" }, "<C-.>", vim.lsp.buf.code_action, { silent = true })
vim.keymap.set("n", "<leader>2", vim.lsp.buf.rename, { silent = true })
vim.keymap.set("n", "gt", vim.lsp.buf.hover, { silent = true })
vim.keymap.set("i", "<c-i>", function()
  if cmp.visible() then
    cmp.abort()
  end
  vim.lsp.buf.signature_help()
end, { silent = true })
vim.keymap.set("n", "gh", open_float, { silent = true })
vim.keymap.set("n", ASquareRight, definition_or_references, { silent = true })
vim.keymap.set("n", "<C-k>", goto_next_diagnostic, { silent = true })


