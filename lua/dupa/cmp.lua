local cmp = safe_require("cmp")
local compare = safe_require("cmp.config.compare")
local keymap = require("cmp.utils.keymap")
local feedkeys = require("cmp.utils.feedkeys")
local luasnip = safe_require("luasnip")
local lspkind = safe_require("lspkind")

if not cmp or not luasnip then
	return
end

local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

local function selectNextOption(fallback)
	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.expandable() then
		luasnip.expand()
	elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	elseif check_backspace() then
		fallback()
	else
		fallback()
	end
end

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-Space>"] = cmp.mapping.complete(),
		["<Esc>"] = cmp.mapping({
			i = function()
				cmp.mapping.abort()
				vim.cmd("stopinsert")
			end,
		}),
		["<CR>"] = function(fallback)
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif not cmp.confirm({ select = true }) then
				fallback()
			end
		end,
		["<Up>"] = cmp.mapping.select_prev_item(),
		["<Down>"] = cmp.mapping(selectNextOption, { "i", "s" }),
		["<Tab>"] = {
			i = function()
				if cmp.visible() then
					cmp.select_next_item()
				else
					feedkeys.call(keymap.t("<tab>"), "n")
				end
			end,
		},
		["<S-Tab>"] = {
			i = function()
				if cmp.visible() then
					cmp.select_prev_item()
				else
					feedkeys.call(keymap.t("<tab>"), "n")
				end
			end,
		},
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = lspkind.cmp_format({
			mode = "symbol",
			maxwidth = 50,
			before = function(entry, vim_item)
				vim_item.menu = ({
					nvim_lsp = "[LSP]",
					luasnip = "[Snippet]",
					buffer = "",
					path = "[Path]",
				})[entry.source.name]

				vim_item.kind = ({
					nvim_lsp = vim_item.kind,
					luasnip = vim_item.kind,
					buffer = "",
					path = vim_item.kind,
				})[entry.source.name]

				return vim_item
			end,
		}),
	},
	sorting = {
		priority_weight = 1.0,
		comparators = {
			-- compare.score_offset, -- not good at all
			compare.locality,
			compare.recently_used,
			compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
			compare.offset,
			compare.order,
			-- compare.scopes, -- what?
			-- compare.sort_text,
			-- compare.exact,
			-- compare.kind,
			-- compare.length, -- useless
		},
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp", priority = 8 },
		{ name = "luasnip", priority = 7 },
		{ name = "buffer", priority = 7 }, -- first for locality sorting?
		{ name = "nvim_lua", priority = 5 },
		{ name = "path" },
		{ name = "calc", priority = 3 },

		-- { name = "nvim_lsp" },
		-- { name = "luasnip" },
		-- { name = "buffer" },
		-- { name = "path" },
	}),
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
})

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
