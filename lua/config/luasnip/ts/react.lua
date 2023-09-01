local luasnip = require("luasnip")
local utils = require("config.luasnip.utils")

local snippet = luasnip.snippet
local i = luasnip.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  snippet(
    "fc",
    fmt(
      [[
      import React from 'react';

      export interface {}Props {{}}

      export const {}: React.FC<{}Props> = ({{}}) => {{
        return (
          <div>{}</div>
        );
      }};
      ]],
      { utils.file_name(), utils.file_name(), utils.file_name(), i(0) }
    )
  ),
  snippet(
    "ue",
    fmt(
      [[
      useEffect(() => {{
        {}
      }}, [{}])
      ]],
      { i(1), i(0) }
    )
  ),
  snippet(
    "ustate",
    fmt(
      "const [{}, set{}] = useState()",
      {
        i(1),
        utils.mirror(1, function(args)
          return args[1][1]:gsub("^%l", string.upper)
        end),
      }
    )
  ),
}
