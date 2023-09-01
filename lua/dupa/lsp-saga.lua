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

--[[ line 709
  local import_tuples = vim.tbl_filter(function(tuple)
    return tuple[2].title:find("[iI]mport")
  end, action_tuples)

  if #import_tuples == 1 then
    on_user_choice(import_tuples[1])
    vim.notify(import_tuples[1][2].title)
    return
  end

  local function stableInsertionSort(arr, compare)
    compare = compare or function(a, b)
      return a < b
    end

    for i = 2, #arr do
      local key = arr[i]
      local j = i - 1
      while j > 0 and compare(key, arr[j]) do
        arr[j + 1] = arr[j]
        j = j - 1
      end
      arr[j + 1] = key
    end
  end

  stableInsertionSort(action_tuples, function(tuple1, tuple2)
    if tuple1[2].title:lower():find("import") and (not tuple2[2].title:lower():find("import")) then
      return true
    end

    if not tuple1[2].title:lower():find("disable eslint") and (tuple2[2].title:lower():find("disable eslint")) then
      return true
    end

    return false
  end)
--]]
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
