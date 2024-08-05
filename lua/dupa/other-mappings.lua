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
  { "<leader>co", "<cmd>DiffviewOpen<cr>", desc = "Open diffview", remap = false },
  { "<leader>dd", "<cmd>diffoff<CR>", desc = "Close fugitive diff", remap = false },
  { "<leader>de", "<cmd>Gitsigns prev_hunk<CR>", desc = "Previous hunk", remap = false },
  { "<leader>dn", "<cmd>Gitsigns next_hunk<CR>", desc = "Next hunk", remap = false },
  { "<leader>dp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview hunk", remap = false },
  { "<leader>dr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reset hunk", remap = false },
  {
    "<leader>fL",
    "<cmd>lua require('utils.telescope-custom-pickers').last_picker()<CR>",
    desc = "Last find window with index",
    remap = false,
  },
  {
    "<leader>ff",
    "<cmd>lua require('telescope.builtin').live_grep({ glob_pattern = '!package-lock.json'})<CR>",
    desc = "Live grep",
    remap = false,
  },
  {
    "<Tab>",
    "<cmd>lua require('telescope.builtin').oldfiles({file_ignore_patterns = {}})<CR>",
    desc = "Old files",
    remap = false,
  },
  {
    "<leader>fh",
    "<cmd>lua require('telescope.builtin').command_history()<CR>",
    desc = "Command history",
    remap = false,
  },
  {
    "<leader>fl",
    "<cmd>lua require('telescope.builtin').resume()<CR>",
    desc = "Last find window",
    remap = false,
  },
  {
    "<leader>fo",
    "<cmd>lua require('utils.telescope-custom-pickers').open_saved_project_picker()<CR>",
    desc = "Projects",
    remap = false,
  },
  {
    "<leader>fp",
    "<cmd>lua require('telescope').extensions.smart_open.smart_open({cwd_only = true})<CR>",
    desc = "Files",
    remap = false,
  },
  {
    "<leader>fr",
    "<cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
    desc = "Telescope refactorings",
    remap = false,
  },
  {
    "<leader>fs",
    "<cmd>lua require('telescope.builtin').grep_string()<CR>",
    desc = "Grep string",
    remap = false,
  },
  {
    "<leader>ft",
    "<cmd>lua require('telescope.builtin').live_grep({ glob_pattern = '!*.spec.*' })<CR>",
    desc = "Live grep",
    remap = false,
  },
  {
    "<leader>fy",
    "<cmd>lua require('telescope').extensions.yank_history.yank_history()<cr>",
    desc = "Open yank history",
    remap = false,
  },
  { "<leader>ga", "<cmd>Git fetch --all<CR>", desc = "Fetch all", remap = false },
  {
    "<leader>gb",
    "<cmd>lua require('utils.telescope-custom-pickers').checkout_remote_smart()<CR>",
    desc = "Branches",
    remap = false,
  },
  { "<leader>gc", "<cmd>Redir Git commit<CR>", desc = "Commit files", remap = false },
  { "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", desc = "File history", remap = false },
  { "<leader>gg", "<cmd>Git<CR>", desc = "Fugitive", remap = false },
  { "<leader>gl", "<cmd>Git pull<CR>", desc = "Git pull", remap = false },
  {
    "<leader>gm",
    "<cmd>lua require('utils.telescope-custom-pickers').merge_branch()<CR>",
    desc = "Git merge",
    remap = false,
  },
  { "<leader>gn", "<cmd>Redir Git commit --amend<CR>", desc = "Commit ammend", remap = false },
  { "<leader>gp", "<cmd>Git push<CR>", desc = "Git push", remap = false },
  { "<leader>gs", "<cmd>GitNewBranch<CR>", desc = "Switch to new branch", remap = false },
  {
    "<leader>gu",
    "<cmd>lua require('gitlinker').get_buf_range_url('n')<CR>",
    desc = "Get github url/link",
    remap = false,
  },
  {
    "<leader>gv",
    "<cmd>Redir Git commit --no-verify<CR>",
    desc = "Commit no verify",
    remap = false,
  },
  {
    "<leader>ia",
    "<cmd>TSToolsAddMissingImports sync<CR><cmd>lua vim.lsp.buf.format({ timeout_ms = 60000 })<CR>",
    desc = "Add missing imports",
    remap = false,
  },
  {
    "<leader>if",
    "<cmd>TSToolsFixAll sync<CR><cmd>lua vim.lsp.buf.format({ timeout_ms = 60000 })<CR>",
    desc = "Fix all problems",
    remap = false,
  },
  {
    "<leader>io",
    "<cmd>TSToolsOrganizeImports sync<CR><cmd>lua vim.lsp.buf.format({ timeout_ms = 60000 })<CR>",
    desc = "Organize imports",
    remap = false,
  },
  {
    "<leader>ir",
    "<cmd>lua require('utils.treesitter-utils').change_relative_absolute()<cr>",
    desc = "Convert relative to absolute",
    remap = false,
  },
  {
    "<leader>iu",
    "<cmd>TSToolsRemoveUnusedImports sync<CR><cmd>lua vim.lsp.buf.format({ timeout_ms = 60000 })<CR>",
    desc = "Remove unused",
    remap = false,
  },
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
    "<leader>nO",
    "<cmd>lua require('neotest').output.open({ enter = true })<cr>",
    desc = "Full Output",
    remap = false,
  },
  { "<leader>nS", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Stop", remap = false },
  { "<leader>na", "<cmd>lua require('neotest').run.attach()<cr>", desc = "Attach", remap = false },
  {
    "<leader>nf",
    "<cmd>w<cr><cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
    desc = "Run File",
    remap = false,
  },
  {
    "<leader>nl",
    "<cmd>w<cr><cmd>lua require('neotest').run.run_last()<cr>",
    desc = "Run Last",
    remap = false,
  },
  {
    "<leader>nn",
    "<cmd>w<cr><cmd>lua require('neotest').run.run()<cr>",
    desc = "Run Nearest",
    remap = false,
  },
  {
    "<leader>no",
    "<cmd>lua require('neotest').output.open({ enter = true, short = true })<cr>",
    desc = "Short output",
    remap = false,
  },
  {
    "<leader>ns",
    "<cmd>lua require('neotest').summary.open()<cr>",
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
    "<cmd>lua vim.lsp.buf.format({ timeout_ms = 60000 })<CR>",
    desc = "Format with prettier",
    remap = false,
  },
  {
    "<leader>uc",
    "<cmd>TextCaseOpenTelescope<cr>",
    desc = "Open telescope with text case changer",
    remap = false,
  },
  {
    "<leader>ue",
    "<cmd>lua require('utils.treesitter-utils').goto_main_export()<CR>",
    desc = "Go to translation",
    remap = false,
  },
  {
    "<leader>uft",
    "<cmd>lua require('telescope.builtin').live_grep({ glob_pattern = '!*.spec.{ts,tsx,js,jsx}'})<CR>",
    desc = "Live grep without tests",
    remap = false,
  },
  {
    "<leader>ule",
    "<cmd>!/Users/jaroslaw.glegola/.local/share/nvim/mason/packages/eslint_d/node_modules/.bin/eslint_d restart<cr>",
    desc = "Restart eslint server",
    remap = false,
  },
  {
    "<leader>ulp",
    "<cmd>!rm /Users/jaroslaw.glegola/.prettierd<cr><cmd>silent !/Users/jaroslaw.glegola/.local/share/nvim/mason/packages/prettierd/node_modules/.bin/prettierd restart<cr>",
    desc = "Restart prettier server",
    remap = false,
  },
  { "<leader>ulr", "<cmd>LspRestart<cr>", desc = "Restart lsp server", remap = false },
  { "<leader>um", "<cmd>Messages<cr>", desc = "Open messages view", remap = false },
  {
    "<leader>upc",
    '<cmd>lua require("package-info").change_version()<cr>',
    desc = "Change package version",
    remap = false,
  },
  {
    "<leader>upd",
    '<cmd>lua require("package-info").delete()<cr>',
    desc = "Delete package",
    remap = false,
  },
  {
    "<leader>uph",
    '<cmd>lua require("package-info").hide()<cr>',
    desc = "Hide package versions",
    remap = false,
  },
  {
    "<leader>upi",
    '<cmd>lua require("package-info").install()<cr>',
    desc = "Install package",
    remap = false,
  },
  {
    "<leader>ups",
    "<cmd>lua require('package-info').show()<cr>",
    desc = "Show package versions",
    remap = false,
  },
  {
    "<leader>upt",
    '<cmd>lua require("package-info").toggle()<cr>',
    desc = "Toggle package versions",
    remap = false,
  },
  {
    "<leader>upu",
    '<cmd>lua require("package-info").update()<cr>',
    desc = "Update package version",
    remap = false,
  },
  {
    "<leader>urf",
    "<cmd>lua require('spectre').open_file_search()<cr>",
    desc = "Find and replace - Rearch in file",
    remap = false,
  },
  {
    "<leader>url",
    "<cmd>lua require('spectre').resume_last_search()<cr>",
    desc = "Find and replace - Resume last search",
    remap = false,
  },
  {
    "<leader>uro",
    "<cmd>lua require('spectre').open()<cr>",
    desc = "Find and replace - Open",
    remap = false,
  },
  {
    "<leader>urw",
    "<cmd>lua require('spectre').open_visual({select_word=true})<cr>",
    desc = "Find and replace - Seach current word",
    remap = false,
  },
  {
    "<leader>ut",
    "<cmd>lua require('utils.treesitter-utils').goto_translation()<CR>",
    desc = "Go to translation",
    remap = false,
  },
  {
    "<leader>uv",
    "<cmd>lua vim.cmd('! code ' .. vim.api.nvim_buf_get_name(0))<cr>",
    desc = "Open vscode in the file",
    remap = false,
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
}

local visual_keymaps = {
  {
    "<leader>ff",
    "<cmd>lua require('utils.telescope-custom-pickers').find_visual()<CR>",
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
    "<leader>ro",
    "<esc>:lua require('spectre').open_visual()<cr>",
    desc = "Find under cursor",
    remap = false,
  },
  {
    "<leader>uc",
    "<cmd>TextCaseOpenTelescope<cr>",
    desc = "Open telescope with text case changer",
    remap = false,
  },
  { "<leader>y", '"+y', desc = "Yank to global register", remap = false },
}

for _, keymap in ipairs(normal_keymaps) do
  if not keymap.group then
    vim.keymap.set("n", keymap[1], keymap[2], { noremap = not keymap.remap, desc = keymap.desc })
  end
end

for _, keymap in ipairs(visual_keymaps) do
  if not keymap.group then
    vim.keymap.set("v", keymap[1], keymap[2], { noremap = not keymap.remap, desc = keymap.desc })
  end
end
