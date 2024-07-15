local function redir_open_win(buf)
  vim.cmd("botright split | resize 25")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
end

local function redir_vim_command(cmd)
  vim.cmd("redir => output")
  vim.cmd(cmd)
  vim.cmd("redir END")
  local output = vim.fn.split(vim.g.output, "\n")
  local errors = vim.tbl_filter(function(line)
    return string.match(line, "code %d %((error)")
  end, output)

  if #errors == 0 then
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, 0, false, output)

  redir_open_win(buf)
end

local function redir(args)
  redir_vim_command(args.args)
end

vim.api.nvim_create_user_command("Redir", redir, {
  nargs = "+",
  complete = "command",
  range = true,
  bang = true,
})
