local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

vim.keymap.set({ "n", "x", "o" }, "k", require("improved-search").stable_next)
vim.keymap.set({ "n", "x", "o" }, "K", require("improved-search").stable_previous)

local wrap_with_paste_autocmds = function(action)
  return function()
    vim.api.nvim_exec_autocmds("User", { pattern = "PastePre" })
    action()
    vim.schedule(function()
      vim.api.nvim_exec_autocmds("User", { pattern = "PastePost" })
    end)
  end
end

-- Plugins
vim.keymap.set(
  { "n" },
  "p",
  wrap_with_paste_autocmds(function()
    vim.cmd("norm! p")
  end)
)

vim.keymap.set(
  { "n" },
  "P",
  wrap_with_paste_autocmds(function()
    vim.cmd("norm! P")
  end)
)

vim.keymap.set(
  { "n" },
  "<leader>r",
  wrap_with_paste_autocmds(function()
    require("substitute").operator()
  end)
)

vim.keymap.set(
  { "n" },
  "<leader>rr",
  wrap_with_paste_autocmds(function()
    require("substitute").line()
  end)
)
keymap("n", "<leader>rI", "<leader>r$", { noremap = false })
keymap("n", "dI", "d$", { noremap = false })

keymap("n", "m", "mm", opts)
vim.keymap.set("n", "<leader>m", function()
  local m_mark = vim.api.nvim_buf_get_mark(0, "m")
  if m_mark[1] == 0 and m_mark[2] == 0 then
    vim.notify("No mark set")
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)

  vim.api.nvim_win_set_cursor(0, m_mark)

  vim.api.nvim_buf_set_mark(0, "m", cursor[1], cursor[2], {})
end, { noremap = true, desc = "Set custom mark" })

vim.keymap.set("n", "<LeftMouse>", function() end)

vim.keymap.set("x", "<leader>ux", require("substitute.exchange").visual, { noremap = true })
-- removing default keymaps for hydra to work without delay
vim.keymap.del("n", "<c-w><c-d>")
vim.keymap.del("n", "<c-w>d")

local normal_keymaps = {
  { "<leader>X", "<cmd>%bd|e#<CR>", desc = "Close all buffers except current one", remap = false },
  { "<leader>cc", "<cmd>DiffviewClose<cr>", desc = "Close diffview", remap = false },
  {
    "<leader>co",
    "<cmd>lua require('vscode').action('workbench.view.scm')<CR>",
    desc = "Open diffview",
    remap = false,
  },
  { "<leader>de", "<cmd>Gitsigns prev_hunk<CR>", desc = "Previous hunk", remap = false },
  {
    "<leader>dn",
    "<cmd>lua require('vscode').action('workbench.action.editor.nextChange')<CR>",
    desc = "Next hunk",
    remap = false,
  },
  {
    "<leader>dp",
    "<cmd>lua require('vscode').action('editor.action.dirtydiff.next')<CR>",
    desc = "Preview hunk",
    remap = false,
  },
  {
    "<leader>dr",
    "<cmd>lua require('vscode').action('git.revertSelectedRanges')<CR>",
    desc = "Reset hunk",
    remap = false,
  },
  -- {
  --   "<leader>fL",
  --   "<cmd>lua require('utils.telescope-custom-pickers').last_picker()<CR>",
  --   desc = "Last find window with index",
  --   remap = false,
  -- },
  {
    "<leader>ff",
    "<cmd>lua require('vscode').action('workbench.action.findInFiles')<CR>",
    desc = "Live grep",
    remap = false,
  },
  {
    "<Tab>",
    "<cmd>lua require('vscode').action('runCommands', { args = { commands = {'workbench.action.quickOpenPreviousRecentlyUsedEditor','list.focusDown'} } })<CR>",
    desc = "Old files",
    remap = false,
  },
  {
    "<leader>fh",
    "<cmd>lua require('vscode').action('workbench.action.showCommands')<CR>",
    desc = "Command history",
    remap = false,
  },
  {
    "q",
    function()
      if vim.fn.reg_recording() == "" then
        -- require("telescope").extensions.smart_open.smart_open({ cwd_only = true })
        require("vscode").action("workbench.action.quickOpen")
      else
      end
    end,
    desc = "Files",
    remap = false,
  },
  {
    -- TODO
    "<leader>ft",
    "<cmd>lua require('telescope.builtin').live_grep({ glob_pattern = '!*.spec.*' })<CR>",
    desc = "Live grep",
    remap = false,
  },
  {
    -- TODO
    "<leader>fy",
    "<cmd>lua require('telescope').extensions.yank_history.yank_history()<cr>",
    desc = "Open yank history",
    remap = false,
  },
  {
    "<leader>ga",
    "<cmd>lua require('vscode').action('git.fetchAll')<CR>",
    desc = "Fetch all",
    remap = false,
  },
  {
    "<leader>gb",
    "<cmd>lua require('vscode').action('git.checkout')<CR>",
    desc = "Branches",
    remap = false,
  },
  {
    "<leader>gc",
    "<cmd>lua require('vscode').action('git.commit')<CR>",
    desc = "Commit files",
    remap = false,
  },
  --todo
  { "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", desc = "File history", remap = false },
  {
    "<leader>gg",
    "<cmd>lua require('vscode').action('workbench.view.scm')<CR>",
    desc = "Fugitive",
    remap = false,
  },
  {
    "<leader>gl",
    "<cmd>lua require('vscode').action('git.pull')<CR>",
    desc = "Git pull",
    remap = false,
  },
  {
    "<leader>gm",
    "<cmd>lua require('vscode').action('git.merge')<CR>",
    desc = "Git merge",
    remap = false,
  },
  {
    "<leader>gn",
    "<cmd>lua require('vscode').action('git.commitAmmend')<CR>",
    desc = "Commit ammend",
    remap = false,
  },
  {
    "<leader>gp",
    "<cmd>lua require('vscode').action('git.push')<CR>",
    desc = "Git push",
    remap = false,
  },
  {
    "<leader>gs",
    "<cmd>lua require('vscode').action('git.branch')<CR>",
    desc = "Switch to new branch",
    remap = false,
  },
  {
    "<leader>gu",
    "<cmd>lua require('gitlinker').get_buf_range_url('n')<CR>",
    desc = "Get github url/link",
    remap = false,
  },
  {
    "<leader>gv",
    "<cmd>lua require('vscode').action('git.commitNoVerify')<CR>",
    desc = "Commit no verify",
    remap = false,
  },
  {
    "<leader>ia",
    "<cmd>lua require('vscode').action('editor.action.sourceAction', { args = { kind= 'source.addMissingImports', apply= 'first' } })<CR>",
    desc = "Add missing imports",
    remap = false,
  },
  {
    "<leader>if",
    "<cmd>lua require('vscode').action('editor.action.sourceAction', { args = { kind= 'source.fixAll', apply= 'first' } })<CR>",
    desc = "Fix all problems",
    remap = false,
  },
  {
    "<leader>io",
    "<cmd>lua require('vscode').action('editor.action.sourceAction', { args = { kind= 'source.organizeImports', apply= 'first' } })<CR>",
    desc = "Organize imports",
    remap = false,
  },
  {
    "<leader>iu",
    "<cmd>lua require('vscode').action('editor.action.sourceAction', { args = { kind= 'source.removeUnused', apply= 'first' } })<CR>",
    desc = "Remove unused",
    remap = false,
  },
  --TODO
  {
    "<leader>nF",
    "<cmd>w<cr><cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
    desc = "Debug File",
    remap = false,
  },
  {
    "<leader>nL",
    "<cmd>w<cr><cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<cr>",
    desc = "Debug Last",
    remap = false,
  },
  {
    "<leader>nN",
    "<cmd>w<cr><cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
    desc = "Debug Nearest",
    remap = false,
  },
  {
    "<leader>nf",
    "<cmd>lua require('vscode').action('testing.runCurrentFile')<CR>",
    desc = "Run File",
    remap = false,
  },
  {
    "<leader>nl",
    "<cmd>lua require('vscode').action('testing.reRunLastRun')<CR>",
    desc = "Run Last",
    remap = false,
  },
  {
    "<leader>nn",
    "<cmd>lua require('vscode').action('testing.runAtCursor')<CR>",
    desc = "Run Nearest",
    remap = false,
  },
  {
    "<leader>ns",
    "<cmd>lua require('vscode').action('workbench.view.testing.focus')<CR>",
    desc = "Summary",
    remap = false,
  },
  {
    "<leader>oc",
    "<cmd>lua require('other-nvim').open('component')<CR>",
    desc = "Find component",
    remap = false,
  },
  {
    "<leader>op",
    "<cmd>lua require('other-nvim').open('stylesheet')<CR>",
    desc = "Find module less/pcss file",
    remap = false,
  },
  {
    "<leader>os",
    "<cmd>lua require('other-nvim').open('style')<CR>",
    desc = "Find style file",
    remap = false,
  },
  {
    "<leader>ot",
    "<cmd>lua require('other-nvim').open('test')<CR>",
    desc = "Find test file",
    remap = false,
  },
  {
    "<leader>p",
    "<cmd>lua require('vscode').action('editor.action.formatDocument')<CR>",
    desc = "Format with prettier",
    remap = false,
  },
  {
    "<leader>uc",
    "<cmd>lua require('vscode').action('workbench.action.quickOpen', {args = {'>Transform to '} })<CR>",
    desc = "Open telescope with text case changer",
    remap = false,
  },
  -- TODO
  {
    "<leader>ue",
    "<cmd>lua require('utils.treesitter-utils').goto_main_export()<CR>",
    desc = "Go to translation",
    remap = false,
  },
  {
    "<leader>uft",
    -- "<cmd>lua require('telescope.builtin').live_grep({ glob_pattern = '!*.spec.{ts,tsx,js,jsx}'})<CR>",
    "<cmd>lua require('vscode').action('workbench.action.findInFiles', { args =  {filesToExclude = '!*.spec.{ts,tsx,js,jsx}'} })<CR>",
    desc = "Live grep without tests",
    remap = false,
  },
  {
    "<leader>ule",
    "<cmd>lua require('vscode').action('eslint.restart')<CR>",
    desc = "Restart eslint server",
    remap = false,
  },
  {
    "<leader>ulp",
    "<cmd>!rm /Users/jaroslaw.glegola/.prettierd<cr><cmd>silent !/Users/jaroslaw.glegola/.local/share/nvim/mason/packages/prettierd/node_modules/.bin/prettierd restart<cr>",
    desc = "Restart prettier server",
    remap = false,
  },
  -- TODO
  {
    "<leader>urf",
    "<cmd>lua require('vscode').action('workbench.action.replaceInFiles')<CR>",
    desc = "Find and replace - Rearch in file",
    remap = false,
  },
  -- TODO
  {
    "<leader>ut",
    "<cmd>lua require('utils.treesitter-utils').goto_translation()<CR>",
    desc = "Go to translation",
    -- remap = false,
  },
  { "<leader>w", "<cmd>wall<CR>", desc = "Save", remap = false },
  { "<leader>x", "<cmd>quit<CR>", desc = "Close buffer", remap = false },

  {
    "<leader>ux",
    require("substitute.exchange").operator,
    desc = "Exchange operator",
    remap = false,
  },
  { "<leader>uxx", require("substitute.exchange").line, desc = "Exchange line", remap = false },
  { "<leader>uxc", require("substitute.exchange").cancel, remap = false },
  {
    "<CR>",
    "<cmd>lua require('vscode').action('workbench.view.explorer')<CR>",
    remap = false,
  },
  {
    "zc",
    "<cmd>lua require('vscode').action('editor.fold')<CR>",
    remap = false,
  },
  {
    "zo",
    "<cmd>lua require('vscode').action('editor.unfold')<CR>",
    remap = false,
  },
  {
    "l",
    "<cmd>lua require('vscode').action('cursorRight')<CR>",
    remap = false,
  },
  {
    "n",
    function()
      if vim.v.count > 0 then
        vim.api.nvim_input(vim.v.count .. "<down>")
      else
        require("vscode").action("cursorDown")
      end
    end,
    remap = false,
  },
  {
    "e",
    function()
      if vim.v.count > 0 then
        vim.api.nvim_input(vim.v.count .. "<up>")
      else
        require("vscode").action("cursorUp")
      end
    end,
    remap = false,
  },
  {
    "h",
    "<cmd>lua require('vscode').action('cursorLeft')<CR>",
    remap = false,
  },
  {
    "N",
    "<cmd>lua require('vscode').action('runCommands', { args = { commands = {'cursorDown','cursorDown','cursorDown','cursorDown','cursorDown','cursorDown','cursorDown','cursorDown','cursorDown'} } })<CR>",
    remap = false,
  },
  {
    "E",
    "<cmd>lua require('vscode').action('runCommands', { args = { commands = {'cursorUp','cursorUp','cursorUp','cursorUp','cursorUp','cursorUp','cursorUp','cursorUp','cursorUp'} } })<CR>",
    remap = false,
  },
  {
    "<leader>ac",
    "<cmd>lua require('vscode').action('workbench.action.chat.open')<CR>",
    remap = false,
  },
  {
    "<leader>ae",
    "<cmd>lua require('vscode').action('workbench.action.chat.openEditSession')<CR>",
    remap = false,
  },
  {
    "<leader>at",
    "<cmd>lua require('vscode').action('workbench.panel.chat')<CR>",
    remap = false,
  },
}

local visual_keymaps = {
  {
    "<leader>ff",
    "<cmd>lua require('vscode').action('workbench.action.findInFiles', { args =  {filesToExclude = ''} })<CR>",
    desc = "Find word under cursor",
    remap = false,
  },
  {
    "<leader>fy",
    "<cmd>lua require('telescope').extensions.yank_history.yank_history()<cr>",
    desc = "Open yank history",
    remap = false,
  },
  {
    "<leader>gu",
    "<cmd>lua require('gitlinker').get_buf_range_url('v')<CR>",
    desc = "Get github url/link",
    remap = false,
  },
  {
    "<leader>uc",
    "<cmd>lua require('vscode').action('workbench.action.quickOpen', {args = {'>Transform to '} })<CR>",
    desc = "Open telescope with text case changer",
    remap = false,
  },
  { "<leader>y", '"+y', desc = "Yank to global register", remap = false },
}

for _, keymap in ipairs(normal_keymaps) do
  if not keymap.group then
    -- vim.api.nvim_set_keymap()
    vim.keymap.set("n", keymap[1], keymap[2], { noremap = not keymap.remap, desc = keymap.desc })
  end
end

for _, keymap in ipairs(visual_keymaps) do
  if not keymap.group then
    vim.keymap.set("v", keymap[1], keymap[2], { noremap = not keymap.remap, desc = keymap.desc })
  end
end
