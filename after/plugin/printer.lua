require("printer").setup({
  keymap = "<leader>l", -- Plugin doesn't have any keymaps by default
  formatters = {
    typescriptreact = function(inside, variable)
      return string.format('console.log("%s: ",  %s)', inside, variable)
    end,
    lua = function(text_inside, text_var)
      return string.format("print([[%s: ]] .. vim.inspect(%s))", text_inside, text_var)
    end,
  },
  add_to_inside = function(text)
    local splitFilename = vim.split(vim.fn.expand("%"), "/")
    return string.format("[%s:%s] -- %s", splitFilename[#splitFilename], vim.fn.line("."), text)
  end,
})


