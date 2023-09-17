local which_key = require("which-key")

if not which_key then
  return
end

local setup = {
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = false,
      nav = false,
      z = true,
      g = true,
    },
  },
  window = {
    border = "rounded",
    position = "bottom",
    margin = { 1, 0, 1, 0 },
    padding = { 2, 2, 2, 2 },
    winblend = 0,
  },
  ignore_missing = true,
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
  show_help = false,
  triggers = "auto",
}

local opts = {
  mode = "n",
  prefix = "<leader>",
  silent = true,
  noremap = true,
}

local format_command = "<cmd>lua vim.lsp.buf.format({ timeout_ms = 60000 })<CR>"

local mappings = {
  ["w"] = { "<cmd>wall<CR>", "Save" },
  ["q"] = { "<cmd>wall<CR><cmd>qall<CR>", "Save and Quit" },
  ["x"] = { "<cmd>quit<CR>", "Close buffer" },
  ["p"] = { format_command, "Format with prettier" },
  ["s"] = { "<Plug>(leap-forward-to)", "Leap forward" },
  ["S"] = { "<Plug>(leap-backward-to)", "Leap backwards" },
  ["c"] = { "<cmd>DiffviewToggle<cr>", "Toggle diffview" },
  ["o"] = {
    name = "Other files",
    ["t"] = { "<cmd>lua require('other-nvim').open('test')<CR>", "Find test file" },
    ["s"] = { "<cmd>lua require('other-nvim').open('style')<CR>", "Find style file" },
    ["m"] = {
      "<cmd>lua require('other-nvim').open('stylesheet')<CR>",
      "Find module less/pcss file",
    },
    ["c"] = { "<cmd>lua require('other-nvim').open('component')<CR>", "Find module less/pcss file" },
  },
  ["t"] = {
    name = "File Explorer",
    ["t"] = { "<cmd>NvimTreeToggle<CR>", "Toggle" },
    ["f"] = { "<cmd>NvimTreeRefresh<CR>", "Refresh" },
    ["c"] = { "<cmd>NvimTreeClose<CR>", "Close" },
    ["o"] = { "<cmd>NvimTreeCollapse<CR>", "Collapse" },
    ["r"] = { "<cmd>TypescriptRenameFile<CR>", "Rename file" },
  },
  ["f"] = {
    name = "Find",
    ["f"] = {
      "<cmd>lua require('telescope.builtin').live_grep({ glob_pattern = '!package-lock.json'})<CR>",
      "Live grep",
    },
    ["l"] = { "<cmd>lua require('telescope.builtin').resume()<CR>", "Last find window" },
    ["L"] = {
      "<cmd>lua require('utils.telescope-custom-pickers').last_picker()<CR>",
      "Last find window with index",
    },
    ["s"] = { "<cmd>lua require('telescope.builtin').grep_string()<CR>", "Grep string" },
    ["r"] = {
      "<cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
      "Telescope refactorings",
    },
    ["p"] = { "<cmd>lua require('telescope.builtin').find_files()<CR>", "Files" },
    ["h"] = { "<cmd>lua require('telescope.builtin').command_history()<CR>", "Command history" },
    ["o"] = {
      "<cmd>lua require('utils.telescope-custom-pickers').open_saved_project_picker()<CR>",
      "Projects",
    },
    ["y"] = {
      "<cmd>lua require('telescope').extensions.yank_history.yank_history()<cr>",
      "Open yank history",
    },
  },
  ["g"] = {
    name = "Git",
    ["s"] = { "<cmd>lua require('telescope.builtin').git_status()<CR>", "Status" },
    ["c"] = { "<cmd>Git commit<CR>", "Commit files" },
    ["n"] = { "<cmd>Git commit --amend<CR>", "Commit ammend" },
    ["v"] = { "<cmd>Git commit --no-verify<CR>", "Commit no verify" },
    ["a"] = { "<cmd>Git fetch --all<CR>", "Fetch all" },
    ["b"] = {
      "<cmd>lua require('utils.telescope-custom-pickers').checkout_remote_smart()<CR>",
      "Branches",
    },
    ["m"] = {
      "<cmd>lua require('utils.telescope-custom-pickers').merge_branch()<CR>",
      "Git merge",
    },
    ["p"] = { "<cmd>Git push<CR>", "Git push" },
    ["l"] = { "<cmd>Git pull<CR>", "Git pull" },
    ["g"] = { "<cmd>Git<CR>", "Fugitive" },
    ["u"] = { "<cmd>lua require('gitlinker').get_buf_range_url('n')<CR>", "Get github url/link" },
    ["f"] = { "<cmd>DiffviewFileHistory %<CR>", "File history" },
    h = {
      name = "+Github",
      c = {
        name = "+Commits",
        c = { "<cmd>GHCloseCommit<cr>", "Close" },
        e = { "<cmd>GHExpandCommit<cr>", "Expand" },
        o = { "<cmd>GHOpenToCommit<cr>", "Open To" },
        p = { "<cmd>GHPopOutCommit<cr>", "Pop Out" },
        z = { "<cmd>GHCollapseCommit<cr>", "Collapse" },
      },
      i = {
        name = "+Issues",
        p = { "<cmd>GHPreviewIssue<cr>", "Preview" },
      },
      l = {
        name = "+Litee",
        t = { "<cmd>LTPanel<cr>", "Toggle Panel" },
      },
      r = {
        name = "+Review",
        b = { "<cmd>GHStartReview<cr>", "Begin" },
        c = { "<cmd>GHCloseReview<cr>", "Close" },
        d = { "<cmd>GHDeleteReview<cr>", "Delete" },
        e = { "<cmd>GHExpandReview<cr>", "Expand" },
        s = { "<cmd>GHSubmitReview<cr>", "Submit" },
        z = { "<cmd>GHCollapseReview<cr>", "Collapse" },
      },
      p = {
        name = "+Pull Request",
        c = { "<cmd>GHClosePR<cr>", "Close" },
        d = { "<cmd>GHPRDetails<cr>", "Details" },
        e = { "<cmd>GHExpandPR<cr>", "Expand" },
        o = { "<cmd>GHOpenPR<cr>", "Open" },
        p = { "<cmd>GHPopOutPR<cr>", "PopOut" },
        r = { "<cmd>GHRefreshPR<cr>", "Refresh" },
        t = { "<cmd>GHOpenToPR<cr>", "Open To" },
        z = { "<cmd>GHCollapsePR<cr>", "Collapse" },
      },
      t = {
        name = "+Threads",
        c = { "<cmd>GHCreateThread<cr>", "Create" },
        n = { "<cmd>GHNextThread<cr>", "Next" },
        t = { "<cmd>GHToggleThread<cr>", "Toggle" },
      },
    },
  },
  ["d"] = {
    name = "Diff View",
    ["d"] = { "<cmd>diffoff<CR>", "Close fugitive diff" },
    ["p"] = { "<cmd>Gitsigns preview_hunk<CR>", "Preview hunk" },
    ["r"] = { "<cmd>Gitsigns reset_hunk<CR>", "Reset hunk" },
    ["n"] = { "<cmd>Gitsigns next_hunk<CR>", "Next hunk" },
    ["e"] = { "<cmd>Gitsigns prev_hunk<CR>", "Previous hunk" },
  },
  ["u"] = {
    name = "Utils",
    ["d"] = { "<cmd>Glow<CR>", "Preview Markdown" },
    ["z"] = { "<cmd>TZAtaraxis<CR>", "Zen mode" },
    ["c"] = { "<cmd>%bd|e#<CR><CR>", "Close all buffers except active" },
    ["m"] = { "<cmd>Messages<cr>", "Open messages view" },
    ["l"] = {
      name = "LSP",
      ["r"] = {
        "<cmd>LspRestart<cr>",
        "Restart lsp server",
      },
      ["e"] = {
        "<cmd>!/Users/jaroslaw.glegola/.local/share/nvim/mason/packages/eslint_d/node_modules/.bin/eslint_d restart<cr>",
        "Restart eslint server",
      },
      ["p"] = {
        "<cmd>!rm /Users/jaroslaw.glegola/.prettierd<cr><cmd>silent !/Users/jaroslaw.glegola/.local/share/nvim/mason/packages/prettierd/node_modules/.bin/prettierd restart<cr>",
        "Restart prettier server",
      },
    },
    ["p"] = {
      name = "Package json actions",
      ["s"] = { "<cmd>lua require('package-info').show()<cr>", "Show package versions" },
      ["h"] = { '<cmd>lua require("package-info").hide()<cr>', "Hide package versions" },
      ["t"] = { '<cmd>lua require("package-info").toggle()<cr>', "Toggle package versions" },
      ["u"] = { '<cmd>lua require("package-info").update()<cr>', "Update package version" },
      ["d"] = { '<cmd>lua require("package-info").delete()<cr>', "Delete package" },
      ["i"] = { '<cmd>lua require("package-info").install()<cr>', "Install package" },
      ["c"] = { '<cmd>lua require("package-info").change_version()<cr>', "Change package version" },
    },
    ["t"] = {
      "<cmd>lua require('utils.treesitter-utils').goto_translation()<CR>",
      "Go to translation",
    },
    ["e"] = {
      "<cmd>lua require('utils.treesitter-utils').goto_main_export()<CR>",
      "Go to translation",
    },
    ["r"] = {
      name = "Find and replace",
      ["o"] = { "<cmd>lua require('spectre').open()<cr>", "Find and replace - Open" },
      ["w"] = {
        "<cmd>lua require('spectre').open_visual({select_word=true})<cr>",
        "Find and replace - Seach current word",
      },
      ["l"] = {
        "<cmd>lua require('spectre').resume_last_search()<cr>",
        "Find and replace - Resume last search",
      },
      ["f"] = {
        "<cmd>lua require('spectre').open_file_search()<cr>",
        "Find and replace - Rearch in file",
      },
    },
  },
  ["i"] = {
    name = "TSTools",
    ["a"] = { "<cmd>TSToolsAddMissingImports sync<CR>" .. format_command, "Add missing imports" },
    ["o"] = { "<cmd>TSToolsOrganizeImports sync<CR>" .. format_command, "Organize imports" },
    ["u"] = { "<cmd>TSToolsRemoveUnusedImports sync<CR>" .. format_command, "Remove unused" },
    ["f"] = { "<cmd>TSToolsFixAll sync<CR>" .. format_command, "Fix all problems" },
    ["r"] = {
      "<cmd>lua require('utils.treesitter-utils').change_relative_absolute()<cr>",
      "Convert relative to absolute",
    },
  },
  ["a"] = {
    name = "Aerial",
    ["o"] = { "<cmd>AerialOpen<CR>", "Open aerial" },
    ["c"] = { "<cmd>AerialClose<CR>", "Close aerial" },
  },
  ["n"] = {
    ["name"] = "Neotest",
    ["a"] = { "<cmd>lua require('neotest').run.attach()<cr>", "Attach" },
    ["f"] = { "<cmd>w<cr><cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Run File" },
    ["F"] = {
      "<cmd>w<cr><cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
      "Debug File",
    },
    ["l"] = { "<cmd>w<cr><cmd>lua require('neotest').run.run_last()<cr>", "Run Last" },
    ["L"] = {
      "<cmd>w<cr><cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<cr>",
      "Debug Last",
    },
    ["n"] = { "<cmd>w<cr><cmd>lua require('neotest').run.run()<cr>", "Run Nearest" },
    ["w"] = {
      "<cmd>w<cr><cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>",
      "Run Nearest watch",
    },
    ["N"] = {
      "<cmd>w<cr><cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
      "Debug Nearest",
    },
    ["O"] = { "<cmd>lua require('neotest').output.open({ enter = true })<cr>", "Full Output" },
    ["o"] = {
      "<cmd>lua require('neotest').output.open({ enter = true, short = true })<cr>",
      "Short output",
    },
    ["S"] = { "<cmd>lua require('neotest').run.stop()<cr>", "Stop" },
    ["s"] = { "<cmd>lua require('neotest').summary.open()<cr>", "Summary" },
  },
}

local visual_opts = {
  mode = "v",
  prefix = "<leader>",
  silent = true,
  noremap = true,
}

local visual_mappings = {
  ["y"] = { '"+y', "Yank to global register" },
  ["r"] = {
    name = "Find and replace",
    ["o"] = { "<esc>:lua require('spectre').open_visual()<cr>", "Find under cursor" },
  },
  ["g"] = {
    name = "Git",
    ["u"] = { "<cmd>lua require('gitlinker').get_buf_range_url('v')<CR>", "Fugitive" },
  },
}

which_key.setup(setup)

which_key.register(mappings, opts)
which_key.register(visual_mappings, visual_opts)
