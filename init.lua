require("dupa.options")
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
require("dupa.lsp-saga")

if not vim.g.vscode then
  require("dupa.other-mappings")
  require("dupa.auto-save")
  require("plugins.other")
  require("config.luasnip")
  require("dupa.redir")
  require("dupa.autocommands")

  require("dupa.import_on_paste")
  require("dupa.definitions_or_references")
else
  require("dupa.other-mappings-vscode")
end

-- when deleting first character of a line, move cursor to indentation of previous line
-- given something like this
--
-- const x = 1
-- ^ <- cursor here in insert mode
-- and when using up arrow cursor lands on the start of the line
