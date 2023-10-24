local M = {}

local plenary = require("plenary.window.float")

--- @param model string
--- @param context string
--- @param prompt string
--- @param buf_nr number
--- @return number returns the job id
M.run = function(model, context, prompt, buf_nr)
  -- prepare the command string
  local cmd = ("ollama run $model $prompt")
    :gsub("$model", model)
    :gsub("$prompt", vim.fn.shellescape(context .. "\n" .. prompt))

  -- print the prompt header
  local header = vim.split(prompt, "\n")
  table.insert(header, "----------------------------------------")
  vim.api.nvim_buf_set_lines(buf_nr, 0, -1, false, header)

  local line = vim.tbl_count(header) + 1
  local words = {}

  -- start the async job
  return vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      for i, token in ipairs(data) do
        if i > 1 then -- if returned data array has more than one element, a line break occured.
          line = line + 1
          words = {}
        end
        table.insert(words, token)
        vim.api.nvim_buf_set_lines(buf_nr, line, line + 1, false, { table.concat(words, "") })
      end
    end,
  })
end

-- The Plenary library provides an easy way to spawn new floating windows,
-- but it’s not entirely necessary and can be accomplished using other methods as well.
-- If you use telescope, you already have it

-- define some styles and spawn a scratch buffer
local win_options = {
  winblend = 10,
  border = "rounded",
  bufnr = vim.api.nvim_create_buf(false, true),
  wrap = true,
}

-- run a simple prompt with the mistral model
vim.keymap.set("n", "<leader><leader><leader>", function()
  plenary.clear(win_options.bufnr)
  local float = plenary.percentage_range_window(0.8, 0.8, win_options)
  M.run("mistral:instruct", "", vim.fn.input("Prompt: "), float.bufnr)
end, { silent = true })

return M
