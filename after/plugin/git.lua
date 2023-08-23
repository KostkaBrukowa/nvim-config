local signs = require("gitsigns")
local git_linker = require("gitlinker")
local utils = require("dupa.utils")

if not signs or not utils or not git_linker then
  return
end

signs.setup({
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
utils.create_onetime_autocmd("FileType", {
  pattern = "gitcommit",
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

git_linker.setup({
  mappings = nil,
})
