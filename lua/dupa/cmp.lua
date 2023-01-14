local cmp = safe_require("cmp")
local keymap = require("cmp.utils.keymap")
local feedkeys = require("cmp.utils.feedkeys")
local luasnip = safe_require("luasnip")
local lspkind = safe_require("lspkind")
local luasnip_vscode_loader = safe_require("luasnip/loaders/from_vscode")

local cmp_kinds_text_only = {
	Text = "Text ",
	Method = "Method ",
	Function = "Function ",
	Constructor = "Constructor ",
	Field = "Field ",
	Variable = "Variable ",
	Class = "Class ",
	Interface = "Interface ",
	Module = "Module ",
	Property = "Property ",
	Unit = "Unit ",
	Value = "Value ",
	Enum = "Enum ",
	Keyword = "Keyword ",
	Snippet = "Snippet ",
	Color = "Color ",
	File = "File ",
	Reference = "Reference ",
	Folder = "Folder ",
	EnumMember = "EnumMember ",
	Constant = "Constant ",
	Struct = "Struct ",
	Event = "Event ",
	Operator = "Operator ",
	TypeParameter = "TypeParameter ",
}

local cmp_kinds = {
	Text = "  ",
	Method = "  ",
	Function = "  ",
	Constructor = "  ",
	Field = "  ",
	Variable = "  ",
	Class = "  ",
	Interface = "  ",
	Module = "  ",
	Property = "  ",
	Unit = "  ",
	Value = "  ",
	Enum = "  ",
	Keyword = "  ",
	Snippet = "  ",
	Color = "  ",
	File = "  ",
	Reference = "  ",
	Folder = "  ",
	EnumMember = "  ",
	Constant = "  ",
	Struct = "  ",
	Event = "  ",
	Operator = "  ",
	TypeParameter = "  ",
}

vim.cmd([[
" gray
highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
" blue
highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
highlight! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch
" light blue
highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
highlight! link CmpItemKindInterface CmpItemKindVariable
highlight! link CmpItemKindText CmpItemKindVariable
" pink
highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
highlight! link CmpItemKindMethod CmpItemKindFunction
" front
highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
highlight! link CmpItemKindProperty CmpItemKindKeyword
highlight! link CmpItemKindUnit CmpItemKindKeyword
]])

if not cmp or not luasnip or not lspkind or not luasnip_vscode_loader then
	return
end

local compare = require("cmp.config.compare")

luasnip_vscode_loader.lazy_load()

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
		format = function(entry, vim_item)
			-- vim_item.menu = ({
			-- 	nvim_lsp = "[[[LSP]]]",
			-- 	luasnip = "[Snippet]",
			-- 	path = "[Path]",
			-- })[entry.source.name]
			vim_item.kind = cmp_kinds[vim_item.kind] or ""
			vim_item.menu = cmp_kinds_text_only[vim_item.kind] or ""
			return vim_item
		end,

		-- format = lspkind.cmp_format({
		-- 	mode = "symbol", -- show only symbol annotations
		-- 	maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
		--
		-- 	-- The function below will be called before any actual modifications from lspkind
		-- 	-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
		-- 	before = function(entry, vim_item)
		-- 		vim_item.kind = (cmp_kinds[vim_item.kind] or "") .. vim_item.kind
		--
		-- 		-- vim_item.menu = ({
		-- 		-- 	nvim_lsp = "[[[LSP]]]",
		-- 		-- 	luasnip = "[Snippet]",
		-- 		-- 	buffer = "[Buffer]",
		-- 		-- 	path = "[Path]",
		-- 		-- })[entry.source.name]
		-- 		-- vim_item.menu = entry:get_completion_item().detail
		-- 		-- print(vim.inspect(entry:get_completion_item()))
		--
		-- 		return vim_item
		-- 	end,
		-- }),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	experimental = {
		ghost_text = false,
		native_menu = false,
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
