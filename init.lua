vim.api.nvim_set_keymap("", "<Space>", "<Nop>", {})
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("dupa.options")
require("dupa.mappings")
require("dupa.lazy-plugin-init")

require("dupa.luasnip")

require("dupa.import_on_paste")
require("dupa.definitions_or_references")

-- todo
-- 3. fix other.nvim
