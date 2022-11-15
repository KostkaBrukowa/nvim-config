local lush = require("lush")

local hsl = lush.hsl

--------------------------------------------------

function hslToRgb(hsl_function)
	local hsl_value = hsl_function()
	local h = hsl_value.h / 360
	local s = hsl_value.s / 100
	local l = hsl_value.l / 100

	local r, g, b, a

	if s == 0 then
		r, g, b = l, l, l -- achromatic
	else
		local function hue2rgb(p, q, t)
			if t < 0 then
				t = t + 1
			end
			if t > 1 then
				t = t - 1
			end
			if t < 1 / 6 then
				return p + (q - p) * 6 * t
			end
			if t < 1 / 2 then
				return q
			end
			if t < 2 / 3 then
				return p + (q - p) * (2 / 3 - t) * 6
			end
			return p
		end

		local q = l < 0.5 and l * (1 + s) or l + s - l * s
		local p = 2 * l - q
		r = hue2rgb(p, q, h + 1 / 3)
		g = hue2rgb(p, q, h)
		b = hue2rgb(p, q, h - 1 / 3)
	end

	if not a then
		a = 1
	end
	--[[ return r * 255, g * 255, b * 255, a * 255 ]]
	return "#" .. math.ceil(r * 255) .. math.ceil(g * 255) .. math.ceil(b * 255)
end

-- GUI options
local bf, it, un = "bold", "italic", "underline"

-- Base colors
local c0 = hsl(240, 1, 15)
local c1 = c0.lighten(5)
local c2 = c1.lighten(2)
local c3 = c2.lighten(20).sa(10)
local c4 = c3.lighten(10)
local c5 = c4.lighten(20)
local c6 = c5.lighten(70)
local c7 = c6.lighten(80)

-- Set base colors
local bg = c0 -- base background
local overbg = c1 -- other backgrounds
local subtle = c2 -- out-of-buffer elements

local fg = hsl(210, 7, 82)
local comment = hsl(0, 0, 54) -- comments
local folder = hsl(202, 9, 57)
local treebg = hsl(220, 3, 19)
local mid = c2.lighten(10) -- either foreground or background
local faded = fg.darken(45) -- non-important text elements
local pop = c7

-- Color palette
local red = hsl(1, 77, 59)
local diff_red = hsl(356, 32, 25)
local salmon = hsl(10, 90, 70)
local orange = hsl(27, 80, 50)
local yellow = hsl(37, 100, 71)

local green = hsl(83, 27, 53)
local dark_green = hsl(137, 28, 27)
local teal = hsl(150, 40, 50)
local cyan = hsl(180, 58, 38)

local blue = hsl(215, 80, 63).li(10)
local hightlight_blue = hsl(220, 60, 32)
local purple = hsl(279, 33, 56)
local light_purple = hsl(282, 29, 64)
local magenta = hsl(310, 40, 70)

require("tokyonight").setup({
	on_colors = function(colors)
		--[[ print(vim.inspect(colors)) ]]

		local config = {
			bg = bg.hex,
			bg_dark = "#1f2335",
			bg_float = "#1f2335",
			bg_highlight = "#292e42",
			bg_popup = "#1f2335",
			bg_search = dark_green.hex,
			bg_sidebar = "#1f2335",
			bg_statusline = "#1f2335",
			bg_visual = "#364a82",
			black = "#1d202f",
			blue = yellow.hex,
			blue0 = "#3d59a1",
			blue1 = fg.hex,
			blue2 = "#0db9d7",
			blue5 = "#89ddff",
			blue6 = "#b4f9f8",
			blue7 = "#394b70",
			border = "#1d202f",
			border_highlight = "#29a4bd",
			comment = "#565f89",
			cyan = orange.hex,
			dark3 = "#545c7e",
			dark5 = "#737aa2",
			diff = {
				add = "#283b4d",
				change = "#272d43",
				delete = "#3f2d3d",
				text = "#394b70",
			},
			error = "#db4b4b",
			fg = "#c0caf5",
			fg_dark = "#a9b1d6",
			fg_float = "#a9b1d6",
			fg_gutter = "#3b4261",
			fg_sidebar = "#a9b1d6",
			git = {
				add = "#449dab",
				change = "#6183bb",
				delete = "#914c54",
				ignore = "#545c7e",
			},
			gitSigns = {
				add = "#266d6a",
				change = "#536c9e",
				delete = "#b2555b",
			},
			green = green.hex,
			green1 = purple.hex,
			green2 = "#41a6b5",
			hint = "#1abc9c",
			info = "#0db9d7",
			magenta = "#bb9af7",
			magenta2 = "#ff007c",
			none = "NONE",
			orange = "#ff9e64",
			purple = orange.hex,
			red = "#f7768e",
			red1 = "#db4b4b",
			teal = "#1abc9c",
			terminal_black = "#414868",
			warning = "#e0af68",
			yellow = fg.hex,
		}

		for key, color in pairs(config) do
			if type(color) == "string" then
				colors[key] = color
			end
		end

		local set_hl = vim.api.nvim_set_hl
		set_hl(0, "@tag", { fg = yellow.hex })
		set_hl(0, "@constructor", { fg = yellow.hex })
		set_hl(0, "@tag.attribute", { fg = fg.hex })
		set_hl(0, "@type.builtin", { fg = orange.hex })
		set_hl(0, "@variable.builtin", { fg = magenta.hex })
		set_hl(0, "@keyword.function", { fg = orange.hex })
		set_hl(0, "@keyword.operator", { fg = orange.hex })

		set_hl(0, "Statement", { fg = orange.hex })
		set_hl(0, "Number", { fg = blue.hex })
		set_hl(0, "SpectreReplace", { bg = diff_red.hex })
	end,
})

vim.o.background = "dark"

--[[ require("lush")(require("lush.colorscheme")) ]]

vim.cmd([[colorscheme tokyonight]])
--[[ vim.cmd("colorscheme darcula-solid") \]\]
--[[ vim.cmd("set termguicolors") ]]
