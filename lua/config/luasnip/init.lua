local luasnip = require("luasnip")

luasnip.config.set_config({
  history = false,
  delete_check_events = "TextChanged",
  --[[ updateevents = "TextChanged,TextChangedI", ]]
})

luasnip.snippets = {}

require("config.luasnip.ts")
require("config.luasnip.lua")
