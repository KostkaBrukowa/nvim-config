return {
    "folke/zen-mode.nvim",
    opts = {
        window = {
            backdrop = 0.95,           -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
            width = 140,               -- width of the Zen window
            height = 1,                -- height of the Zen window
            options = {
                signcolumn = "no",     -- disable signcolumn
                number = true,         -- disable number column
                relativenumber = true, -- disable relative numbers
                cursorline = true,     -- disable cursorline
                cursorcolumn = false,  -- disable cursor column
                foldcolumn = "0",      -- disable fold column
                list = false,          -- disable whitespace characters
            },
        },
        plugins = {
            options = {
                enabled = true,
                ruler = false,   -- disables the ruler text in the cmd line area
                showcmd = false, -- disables the command in the last line of the screen
                laststatus = 0,  -- turn off the statusline in zen mode
            },
            kitty = {
                enabled = false,
            },
        },
    },
    keys = {
        {
            "<leader>z",
            "<cmd>ZenMode<cr>",
            desc = "Toggle Zen Mode",
        },
    },
}
