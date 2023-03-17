local sorters = require("telescope.sorters")

local fuzzy_sorter = sorters.get_generic_fuzzy_sorter()

-- sorter that moves less important entries to the bottom
local sorter = sorters.Sorter:new({
	scoring_function = function(_, prompt, line, entry, cb_add, cb_filter)
		local base_score = fuzzy_sorter:scoring_function(prompt, line, cb_add, cb_filter)

		if entry.value.is_test_file then
			base_score = base_score + 100
		end

		if entry.value.is_inside_import then
			base_score = base_score + 100
		end

		return base_score
	end,
	highlighter = fuzzy_sorter.highlighter,
})

return sorter
