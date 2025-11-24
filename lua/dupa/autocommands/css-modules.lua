local augroup = vim.api.nvim_create_augroup("CssModules", { clear = true })

-- TODO make back go directly to tsx
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.module.css.d.ts", "*.module.pcss.d.ts" },
  group = augroup,
  callback = function()
    vim.defer_fn(function()
      local alt_bufnr = vim.fn.bufnr("#")
      if alt_bufnr == -1 then
        return
      end

      local prev_ft = vim.api.nvim_buf_get_option(alt_bufnr, "filetype")
      if prev_ft ~= "typescript" and prev_ft ~= "typescriptreact" then
        return
      end

      local dts_bufnr = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_set_option(dts_bufnr, "buflisted", false)

      local dts_file_path = vim.api.nvim_buf_get_name(0)
      local css_file_path = dts_file_path:gsub(".d.ts", "")

      if not vim.fn.filereadable(css_file_path) then
        return
      end

      local token = vim.fn.expand("<cword>")

      if token == "" then
        return
      end

      vim.cmd("edit " .. css_file_path)

      vim.fn.search(token)
    end, 100)
  end,
})
