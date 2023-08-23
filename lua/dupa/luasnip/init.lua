local luasnip = require("luasnip")

luasnip.config.set_config({
  history = false,
  delete_check_events = "TextChanged",
  --[[ updateevents = "TextChanged,TextChangedI", ]]
})

luasnip.snippets = {}

require("dupa.luasnip.ts")
require("dupa.luasnip.lua")
