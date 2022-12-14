local other = safe_require("other-nvim")
local list = safe_require("utils.list")

if not other or not list then
	return
end

-- this is overkill, but regex didnt work for me in target property
local function add_all_extensions(target)
	return vim.tbl_map(function(extension)
		local copy = vim.deepcopy(target)
		copy.target = copy.target .. extension
		return copy
	end, { ".js", ".jsx", ".ts", ".tsx" })
end

function TableConcat(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
	return t1
end

local function ts_tests(suffix)
	local test_ext = string.format(".%s.[tj]sx?", suffix)

	return {
		{
			pattern = "/(.*)/(.*).([tj]sx?)$",
			target = TableConcat(
				add_all_extensions({ target = "/%1/__tests__/%2." .. suffix, context = "test" }),
				add_all_extensions({ target = "/%1/%2." .. suffix, context = "test" })
			),
		},
		{
			pattern = "/(.*)/__tests__/(.*)." .. suffix .. ".([tj]sx?)$",
			target = add_all_extensions({ target = "/%1/%2", context = "test" }),
		},
		{
			pattern = "/(.*)/(.*)." .. test_ext .. ".([tj]sx?)$",
			target = add_all_extensions({ target = "/%1/%2", context = "test" }),
		},
	}
end

other.setup({
	mappings = list.extend({}, ts_tests("spec"), ts_tests("test")),
})
