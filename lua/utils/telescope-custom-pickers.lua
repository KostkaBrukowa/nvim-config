local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local action_state = require("telescope.actions.state")
local project_actions = require("telescope._extensions.project.actions")

local M = {}

function M.merge_branch()
  builtin.git_branches({
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection_value = action_state.get_selected_entry().value
        vim.cmd("Git merge " .. selection_value)
      end)

      return true
    end,
  })
end

-- Checkout to searched branch and creates one if branch is remote and doesnt exist
--[[
  This was modified in telescope.nvim to 
    .. "%(objectname)"

  local last_branch_hash = get_git_command_output({ "rev-parse", "@{-1}" }, {})[1]
  ...
    if entry.objectname == last_branch_hash and #entry.upstream > 0 then
      index = 1
    end
-]]
function M.checkout_remote_smart()
  builtin.git_branches({
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection_value = action_state.get_selected_entry().value
        if string.find(selection_value, "origin/") then
          vim.cmd("Git checkout --track " .. selection_value)
        else
          vim.cmd("Git checkout " .. selection_value)
        end

        -- remove buffers that doesn't have corresponding file after switch
        local bufremove = require("mini.bufremove")
        for _, buf in pairs(vim.api.nvim_list_bufs()) do
          local buf_name = vim.api.nvim_buf_get_name(buf)
          if
            vim.fn.filereadable(buf_name) == 0
            and not vim.tbl_contains(
              { "neotest-summary" },
              vim.api.nvim_buf_get_option(buf, "filetype")
            )
          then
            bufremove.delete(buf, true)
          end
        end

        vim.cmd("LspRestart")
      end)

      return true
    end,
  })
end

-- Open project in new kitty window
function M.open_saved_project_picker()
  require("telescope").extensions.project.project({
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection_value = action_state.get_selected_entry().value

        local handle_select_choice = function(picked_option)
          if picked_option == "This window" then
            vim.cmd("e " .. selection_value)
            vim.cmd("cd " .. selection_value)
          elseif picked_option == "New tab" then
            vim.cmd(
              "silent! kitty @ --to=$KITTY_LISTEN_ON launch --type=tab --cwd=" .. selection_value
            )
          end
        end

        vim.ui.select(
          { "New tab", "New window", "This window" },
          { prompt = "Open " .. selection_value .. " in: " },
          handle_select_choice
        )
      end)
      return true
    end,
  })
end

-- If you are in nvimtree and you are focused on some folder this command
-- will open live grep only in this directory
function M.find_in_focused_file(node)
  if node.type == "directory" then
    builtin.live_grep({
      search_dirs = { node.absolute_path },
      prompt_title = "Live grep: " .. node.absolute_path,
    })
  elseif node.parent ~= nil then
    builtin.live_grep({
      search_dirs = { node.parent.absolute_path },
      prompt_title = "Live grep: " .. node.parent.absolute_path,
    })
  end
end

function M.find_file_in_focused_file(node)
  if node.type == "directory" then
    builtin.find_files({
      search_dirs = { node.absolute_path },
      prompt_title = "Find files: " .. node.absolute_path,
    })
  elseif node.parent ~= nil then
    builtin.find_files({
      search_dirs = { node.parent.absolute_path },
      prompt_title = "Find files: " .. node.parent.absolute_path,
    })
  end
end

function M.last_picker(node)
  local handle_input = function(input)
    local input_number = tonumber(input)
    if not input or not input_number then
      return
    end

    builtin.resume({ cache_index = input_number })
  end

  vim.ui.input({
    prompt = "Enter a numer for picker (min. 1): ",
  }, handle_input)
end

function M.find_visual()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", {})

  text = string.gsub(text, "\n", "")

  builtin.live_grep({ default_text = text })
end

return M
