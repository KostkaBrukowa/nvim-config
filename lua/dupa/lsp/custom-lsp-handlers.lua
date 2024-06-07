local M = {}

local original_underline_function_show = vim.diagnostic.handlers.underline.show

M.remove_multiline_underline_handler = function(namespace, bufnr, diagnostics, opts)
  local buf_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  if not buf_lines then
    original_underline_function_show(namespace, bufnr, diagnostics, opts)

    return
  end

  local diagnostics_without_multiline = vim.tbl_map(function(diagnostic)
    if diagnostic._tags and diagnostic._tags.unnecessary == true then
      return diagnostic
    end

    -- only highlight first line of multiline diagnostics
    diagnostic.end_col = diagnostic.lnum == diagnostic.end_lnum and diagnostic.end_col
      or (buf_lines[diagnostic.lnum + 1] and #buf_lines[diagnostic.lnum + 1] or 0)
    diagnostic.end_lnum = diagnostic.lnum

    -- only highlight first word of diagnostic
    local line = vim.api.nvim_buf_get_lines(bufnr, diagnostic.lnum, diagnostic.lnum + 1, false)[1]

    if not line then
      return diagnostic
    end

    local diagnostic_range_string = string.sub(line, diagnostic.col + 1, diagnostic.end_col)
    local first_word = vim.split(diagnostic_range_string, "[ %(),:]", {})[1]
    -- sometimes there are diagnostic that has 1 letter and are ignored by split above and we want to highlight them
    diagnostic.end_col = diagnostic.col + math.max(#first_word, 1)

    return diagnostic
  end, vim.deepcopy(diagnostics))

  original_underline_function_show(namespace, bufnr, diagnostics_without_multiline, opts)
end

local original_virtual_text_function_show = vim.diagnostic.handlers.virtual_text.show

M.add_source_to_virtual_text_handler = function(namespace, bufnr, diagnostics, opts)
  local diagnostics_with_source = vim.tbl_map(function(diagnostic)
    diagnostic.message = string.sub(diagnostic.message, 0, 30)
    diagnostic.message = diagnostic.source and diagnostic.source .. ": " .. diagnostic.message
      or diagnostic.message

    return diagnostic
  end, vim.deepcopy(diagnostics))

  original_virtual_text_function_show(namespace, bufnr, diagnostics_with_source, opts)
end

return M
