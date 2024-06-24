local signs = safe_require("gitsigns")
local git_linker = safe_require("gitlinker")

if not signs or not git_linker then
  return
end

signs.setup({
  on_attach = function(bufnr)
    -- do not attach the fugitive buffers
    if
      vim.startswith(vim.api.nvim_buf_get_name(bufnr), "fugitive://")
      or vim.startswith(vim.api.nvim_buf_get_name(bufnr), "term://")
    then
      return false
    end
  end,
  attach_to_untracked = true,
  signs = {
    add = { hl = "GitSignsAdd", text = "█", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = {
      hl = "GitSignsChange",
      text = "█",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
    delete = {
      hl = "GitSignsDelete",
      text = "▬",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    topdelete = {
      hl = "GitSignsDelete",
      text = "‾",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    changedelete = {
      hl = "GitSignsChange",
      text = "~",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
    untracked = {
      hl = "GitSignsAdd",
      text = "┇",
      numhl = "GitSignsAddNr",
      linehl = "GitSignsAddLn",
    },
  },
})

-- Add jira task to commit message
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  group = vim.api.nvim_create_augroup("git-commit-jira", { clear = true }),
  callback = function()
    local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)[1]

    if content ~= "" and content:find("^Merge branch") == nil then
      return
    end

    local branch = vim.fn.system("git branch --show-current"):match("/?([%u%d]+-%d+)-?")

    if branch then
      vim.api.nvim_buf_set_lines(0, 0, 0, false, { branch .. " | " })
      vim.api.nvim_win_set_cursor(0, { 1, branch:len() + 1 })
      vim.cmd(":startinsert!")
    end
  end,
})

vim.api.nvim_create_user_command("GitNewBranch", function()
  vim.ui.input({
    prompt = "New branch name",
    default = "ADS-",
  }, function(input)
    if not input then
      return
    end
    vim.cmd("Git checkout -b " .. input)
  end)
end, {})

git_linker.setup({
  mappings = nil,
})

vim.api.nvim_create_user_command("DiffviewToggle", function()
  local view = require("diffview.lib").get_current_view()

  if view then
    vim.cmd("DiffviewClose")
  else
    vim.cmd("DiffviewOpen")
  end
end, {})

require("diffview").setup({
  enhanced_diff_hl = true,
  keymaps = {
    view = {
      ["<leader>co"] = false,
      ["<leader>ct"] = false,
      ["<leader>cb"] = false,
      ["<leader>ca"] = false,
      ["<leader>cO"] = false,
      ["<leader>cT"] = false,
      ["<leader>cB"] = false,
      ["<leader>cA"] = false,
    },
    file_panel = {
      ["<leader>cO"] = false,
      ["<leader>cT"] = false,
      ["<leader>cB"] = false,
      ["<leader>cA"] = false,
    },
  },
  hooks = {
    diff_buf_read = function(bufnr) end,
    -- view_opened = function()
    --   vim.cmd("UfoDisable")
    -- end,
    -- view_closed = function()
    --   vim.cmd("UfoEnable")
    -- end,
  },
})
