return {
  "rgroli/other.nvim",
  config = function()
    local other = require("other-nvim")

    local patterns = {
      { pattern = "/(.*)/(.*).([tj]sx?)$", context = "component" },
      { pattern = "/(.*)/__tests__/(.*).spec.([tj]sx?)$", context = "test" },
      { pattern = "/(.*)/__tests__/(.*).test.([tj]sx?)$", context = "test" },
      { pattern = "/(.*)/(.*).spec.([tj]sx?)$", context = "test" },
      { pattern = "/(.*)/(.*).test.([tj]sx?)$", context = "test" },
      { pattern = "/(.*)/(.*).module.less", context = "stylesheet" },
      { pattern = "/(.*)/(.*).module.css", context = "stylesheet" },
      { pattern = "/(.*)/(.*).pcss", context = "stylesheet" },
      { pattern = "/(.*)/(.*).style.ts", context = "style" },
    }

    local targets = {
      { target = "/%1/%2.jsx", context = "component" },
      { target = "/%1/%2.tsx", context = "component" },
      { target = "/%1/*.tsx", context = "component", fallback = true },
      { target = "/%1/%2.js", context = "component" },
      { target = "/%1/%2.ts", context = "component" },
      { target = "/%1/__tests__/%2.spec.ts", context = "test" },
      { target = "/%1/__tests__/%2.spec.tsx", context = "test" },
      { target = "/%1/__tests__/%2.test.ts", context = "test" },
      { target = "/%1/__tests__/%2.test.tsx", context = "test" },
      { target = "/%1/__tests__/*.spec.tsx", context = "test", fallback = true },
      { target = "/%1/%2.spec.ts", context = "test" },
      { target = "/%1/%2.spec.tsx", context = "test" },
      { target = "/%1/%2.test.ts", context = "test" },
      { target = "/%1/%2.test.tsx", context = "test" },
      { target = "/%1/%2.pcss", context = "stylesheet" },
      { target = "/%1/%2.module.pcss", context = "stylesheet" },
      { target = "/%1/%2.module.less", context = "stylesheet" },
      { target = "/%1/%2.module.css", context = "stylesheet" },
      { target = "/%1/*.pcss", context = "stylesheet", fallback = true },
      { target = "/%1/*.module.css", context = "stylesheet", fallback = true },
      { target = "/%1/*.module.less", context = "stylesheet", fallback = true },
      { target = "/%1/%2.style.ts", context = "style" },
    }

    local mappings = vim.tbl_map(function(pattern)
      local targets_without_current_context = vim.tbl_filter(function(target)
        return target.context ~= pattern.context
      end, targets)

      return {
        pattern = pattern.pattern,
        target = targets_without_current_context,
      }
    end, patterns)

    other.setup({
      showMissingFiles = false,
      mappings = mappings,
    })
  end,
}
