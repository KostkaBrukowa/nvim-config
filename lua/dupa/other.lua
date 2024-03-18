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
      target = add_all_extensions({ target = "/%1/%2", context = "component" }),
    },
    {
      pattern = "/(.*)/(.*)." .. test_ext .. ".([tj]sx?)$",
      target = add_all_extensions({ target = "/%1/%2", context = "component" }),
    },
  }
end

other.setup({
  showMissingFiles = false,
  mappings = list.extend({}, ts_tests("spec"), ts_tests("test"), {
    {
      pattern = "/(.*)/(.*).([tj]sx)$",
      target = {
        -- Component.tsx -> Component.style.ts
        {
          target = "/%1/%2.style.ts",
          context = "style",
        },
        -- Component.tsx -> Component.pcss
        {
          target = "/%1/%2.pcss",
          context = "stylesheet",
        },
        -- Component.tsx -> Component.module.less
        {
          target = "/%1/%2.module.less",
          context = "stylesheet",
        },
      },
    },

    {
      pattern = "/(.*)/(.*).module.less",
      target = {
        { -- Component.module.less|pcss -> Component.style.ts
          target = "/%1/%2.style.ts",
          context = "style",
        },
        -- Component.module.less|pcss -> Component.tsx
        {
          target = "/%1/%2.tsx",
          context = "component",
        },
      },
    },
    {
      pattern = "/(.*)/(.*).pcss",
      target = {
        { -- Component.module.less|pcss -> Component.style.ts
          target = "/%1/%2.style.ts",
          context = "style",
        },
        -- Component.module.less|pcss -> Component.tsx
        {
          target = "/%1/%2.tsx",
          context = "component",
        },
      },
    },
    {
      pattern = "/(.*)/(.*).style.ts",
      target = {
        { -- Component.style.ts -> Component.module.less
          target = "/%1/%2.module.less",
          context = "stylesheet",
        },
        { -- Component.style.ts -> Component.pcss
          target = "/%1/%2.pcss",
          context = "stylesheet",
        },
        -- Component.style.ts -> Component.tsx
        {
          target = "/%1/%2.tsx",
          context = "component",
        },
      },
    },
  }),
})
