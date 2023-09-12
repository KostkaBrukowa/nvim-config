local Hydra = require("hydra")

local pcmd = require("hydra.keymap-util").pcmd

local window_hint = [[
 ^^^^^^^^^^^^     Move      ^^    Size   ^^   ^^     Split
 ^^^^^^^^^^^^-------------  ^^-----------^^   ^^---------------
 ^ ^ _e_ ^ ^  ^ ^ _E_ ^ ^   ^   _<C-e>_   ^   _s_: horizontally 
 _h_ ^ ^ _i_  _H_ ^ ^ _I_   _<C-h>_ _<C-i>_   _v_: vertically
 ^ ^ _n_ ^ ^  ^ ^ _N_ ^ ^   ^   _<C-n>_   ^   _q_, _x_: close
 focus^^^^^^  window^^^^^^  ^_=_: equalize^   _o_: remain only
 ^ ^ ^ ^ ^ ^  ^ ^ ^ ^ ^ ^   ^^ ^          ^   
]]

Hydra({
  name = "Windows",
  hint = window_hint,
  config = {
    invoke_on_body = true,
    hint = {
      border = "rounded",
      offset = -1,
    },
  },
  mode = "n",
  body = "<C-w>",
  heads = {
    { "h", "<C-w>h" },
    { "n", "<C-w>j" },
    { "e", pcmd("wincmd k", "E11", "close") },
    { "i", "<C-w>l" },

    { "H", "<c-w>H" },
    { "N", "<c-w>J" },
    { "E", "<c-w>K" },
    { "I", "<c-w>L" },

    { "<C-h>", "<C-w>><C-w>>" },
    { "<C-n>", "<C-w>-<C-w>-" },
    { "<C-e>", "<C-w>+<C-w>+" },
    { "<C-i>", "<C-w><<C-w><" },
    { "=", "<C-w>=", { desc = "equalize" } },

    { "s", pcmd("split", "E36") },
    { "<C-s>", pcmd("split", "E36"), { desc = false } },
    { "v", pcmd("vsplit", "E36") },
    { "<C-v>", pcmd("vsplit", "E36"), { desc = false } },

    { "w", "<C-w>w", { exit = true, desc = false } },
    { "<C-w>", "<C-w>w", { exit = true, desc = false } },

    { "o", "<C-w>o", { exit = true, desc = "remain only" } },
    { "<C-o>", "<C-w>o", { exit = true, desc = false } },

    -- { "b", choose_buffer, { exit = true, desc = "choose buffer" } },

    { "x", pcmd("close", "E444") },
    { "q", pcmd("close", "E444"), { desc = "close window" } },
    { "<C-c>", pcmd("close", "E444"), { desc = false } },
    { "<C-q>", pcmd("close", "E444"), { desc = false } },

    { "<Esc>", nil, { exit = true, desc = false } },
  },
})
