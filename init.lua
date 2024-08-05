require("dupa.keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", { change_detection = { notify = false } })

require("utils.module_utils")
require("dupa.colorscheme")
require("dupa.options")
require("dupa.which-key")
require("dupa.lualine")
require("dupa.other-mappings")

require("dupa.treesitter")
require("dupa.neotree")
require("dupa.telescope")
require("dupa.neodev")
require("dupa.neoconf")
require("dupa.lsp-zero")
require("dupa.impatient")
require("dupa.comment")
require("dupa.lastplace")
require("dupa.dressing")
require("dupa.toggleterm")
require("dupa.auto-save")
require("dupa.spectre")
require("dupa.git")
require("dupa.other")
require("dupa.neotest")
require("dupa.dap")
require("config.luasnip")
require("dupa.hydra")
require("dupa.ufo")
require("dupa.other_plugins")
require("dupa.lsp-saga")
require("dupa.printer")
require("dupa.copilot")
require("dupa.yanky")
require("dupa.diagflow")
require("dupa.fidget")
require("dupa.redir")
require("dupa.autocommands")

require("dupa.typescript-tools")

require("dupa.import_on_paste")
require("dupa.definitions_or_references")
