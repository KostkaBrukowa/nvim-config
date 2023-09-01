function P(arg)
  -- print(vim.inspect(arg))
end

require("utils.module_utils")

reload("dupa.colorscheme")
reload("dupa.options")
reload("dupa.mappings")
reload("dupa.which-key")
require("dupa.lualine")

require("dupa.packer-plugins")
require("dupa.treesitter")
require("dupa.nvim-tree")
require("dupa.telescope")
require("dupa.neodev")
require("dupa.lsp-zero")
require("dupa.autopairs")
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
require("dupa.auto-session")
require("dupa.hydra")
-- require("dupa.ufo")
require("dupa.stickybuf")
require("dupa.aerial")
require("dupa.other_plugins")
require("dupa.lsp-saga")
require("dupa.printer")
-- require("dupa.copilot")
require("dupa.no-neck-pain")
require("dupa.multicursors")
require("dupa.yanky")

require("dupa.typescript-tools")

require("dupa.import_on_paste")
require("dupa.definitions_or_references")

vim.api.nvim_create_user_command("ReloadConfig", function()
  reload("init")
  vim.notify("Reloaded whole config")
end, {})

-- todo
-- 2. Remove annotation from buffer cmp
-- 3. fix other.nvim
