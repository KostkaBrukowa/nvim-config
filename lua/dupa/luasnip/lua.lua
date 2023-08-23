local luasnip = require("luasnip")
local utils = require("dupa.luasnip.utils")

luasnip.add_snippets("lua", vim.list_extend({}, utils.print_snip("log", "P")))
