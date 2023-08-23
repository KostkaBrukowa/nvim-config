vim.filetype.add({
  extension = {
    pcss = "postcss",
  },
  pattern = {
    [".*%.css"] = function(_, bufnr)
      local content = vim.filetype.getlines(bufnr)

      for _, line in ipairs(type(content) == "table" and content or { content }) do
        if vim.filetype.matchregex(line, [[^\s*composes:.*$]]) then
          return "postcss"
        end
      end

      return "css"
    end,
  },
})
