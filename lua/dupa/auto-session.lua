local session = require("auto-session")
local tree_utils = require("utils.tree")

if not session then
  return
end

--print("session")
session.setup({
  log_level = "error",
  auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
  pre_save_cmds = { 'lua require("dupa.auto-session").close_plugin_owned()' },
  auto_session_use_git_branch = false,
})

local M = {}
M.close_plugin_owned = function()
  -- Jump to preview window if current window is plugin owned.
  if M.is_plugin_owned(0) then
    vim.cmd([[ wincmd p ]])
  end

  for _, win in ipairs(vim.fn.getwininfo()) do
    if M.is_plugin_owned(win.bufnr) then
      -- Delete plugin owned window buffers.
      vim.api.nvim_buf_delete(win.bufnr, {})
    end
  end
end

-- Detect if window is owned by plugin by checking buftype.
M.is_plugin_owned = function(bufid)
  local origin_type = vim.api.nvim_buf_get_option(bufid, "buftype")

  if origin_type == "" or origin_type == "help" then
    return false
  end

  return true
end

return M

--[[ local file_utils = require("utils.file") ]]
--[[]]
--[[ local M = {} ]]
--[[]]
--[[ vim.g.session_dir = vim.fn.stdpath("data") .. "/sessions/" ]]
--[[]]
--[[ if vim.fn.isdirectory(vim.g.session_dir) == 0 then ]]
--[[ 	vim.fn.mkdir(vim.g.session_dir, "p") ]]
--[[ end ]]
--[[]]
--[[ local function get_session_name() ]]
--[[ 	if vim.fn.trim(vim.fn.system("git rev-parse --is-inside-work-tree")) == "true" then ]]
--[[ 		return vim.g.session_dir .. vim.fn.trim(vim.fn.system("git rev-parse --show-toplevel")):gsub("/", "_") ]]
--[[ 	end ]]
--[[]]
--[[ 	return nil ]]
--[[ end ]]
--[[]]
--[[ local function make_session(session_name) ]]
--[[ 	local cmd = "mks! " .. session_name ]]
--[[ 	vim.cmd(cmd) ]]
--[[ end ]]
--[[]]
--[[ local function restore_session() ]]
--[[ 	local session_name = get_session_name() ]]
--[[]]
--[[ 	if session_name ~= nil and file_utils.file_exists(session_name) then ]]
--[[ 		local cmd = "silent! source " .. session_name ]]
--[[ 		vim.cmd(cmd) ]]
--[[ 	end ]]
--[[ end ]]
--[[]]
--[[ restore_session() ]]
--[[]]
--[[ -- Create autocmd ]]
--[[ vim.api.nvim_create_autocmd("VimLeave", { ]]
--[[ 	callback = function() ]]
--[[ 		local session_name = get_session_name() ]]
--[[ 		if session_name ~= nil then ]]
--[[ 			make_session(session_name) ]]
--[[ 		end ]]
--[[ 	end, ]]
--[[ }) ]]
--[[]]
--[[ -- todo add pre save command ]]
--[[]]
--[[ return M ]]
--
