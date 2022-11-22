local luasnip = require("luasnip")

luasnip.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
})

luasnip.snippets = {}

require("config.luasnip.ts")
require("config.luasnip.lua")
