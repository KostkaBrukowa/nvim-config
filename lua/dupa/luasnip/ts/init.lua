local luasnip = require("luasnip")
local utils = require("dupa.luasnip.utils")

local snippet = luasnip.snippet
local i = luasnip.insert_node
local f = luasnip.function_node
local fmt = require("luasnip.extras.fmt").fmt

local jsTsSnippets = {
  snippet(
    "jds",
    fmt(
      [[
      describe('{}', () => {{
        {}
      }})
      ]],
      { i(1), i(0) }
    )
  ),
  snippet(
    "jit",
    fmt(
      [[
      it('should {}', () => {{
        {}
      }})
      ]],
      { i(1), i(0) }
    )
  ),
  snippet("fln", { utils.file_name(true) }),
  snippet("clg", fmt("console.log('{}', {}){};", { utils.mirror(1), i(1), i(0) })),
  luasnip.parser.parse_snippet(
    "testfile",
    [[
describe('<${TM_FILENAME}$2 />', () => {
  it('should', () => {
      // given
      const wrapper = $0render(<$TM_FILENAME_BASE$3 />());
      
      // when

      // then
  });
});
    ]]
  ),
}

vim.list_extend(jsTsSnippets, require("dupa.luasnip.ts.react"))

for _, suffix in pairs({ "log", "dir", "error", "trace" }) do
  vim.list_extend(jsTsSnippets, utils.print_snip(suffix, "console." .. suffix))
end

for _, ft in pairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
  luasnip.add_snippets(ft, jsTsSnippets)
end
