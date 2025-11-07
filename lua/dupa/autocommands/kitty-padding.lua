-- Kitty padding management
local initial_width = nil

local function set_kitty_padding()
    -- Only proceed if we're running in Kitty
    if vim.env.KITTY_WINDOW_ID == nil or vim.env.KITTY_WINDOW_ID == "" then
        return
    end

    -- Count vertical splits (windows side by side, not stacked)
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local columns = {}

    for _, win in ipairs(wins) do
        -- Check if window is valid and not floating
        if vim.api.nvim_win_is_valid(win) then
            local config = vim.api.nvim_win_get_config(win)
            if config.relative == "" then -- Not a floating window
                -- Get window position (column position)
                local win_pos = vim.api.nvim_win_get_position(win)
                local col = win_pos[2] -- Column (horizontal position)

                -- Track unique column positions (different columns = vertical splits)
                if not vim.tbl_contains(columns, col) then
                    table.insert(columns, col)
                end
            end
        end
    end

    -- If more than one column (vertical split), remove padding
    if #columns > 1 then
        vim.fn.system("kitty @ set-spacing padding-left=0 2>/dev/null")
        return
    end

    -- Use saved initial width for padding calculation
    if not initial_width then
        return
    end

    local padding = math.floor(initial_width * 1.7)

    -- Apply padding
    vim.fn.system(string.format("kitty @ set-spacing padding-left=%d 2>/dev/null", padding))
end

-- Create autogroup for Kitty padding
local kitty_group = vim.api.nvim_create_augroup("KittyPadding", { clear = true })

-- Set padding on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
    group = kitty_group,
    desc = "Set Kitty padding on Vim enter",
    callback = function()
        vim.defer_fn(function()
            -- Save initial width on startup
            initial_width = vim.o.columns
            set_kitty_padding()
        end, 50)
    end,
})

-- Update padding when window layout changes
vim.api.nvim_create_autocmd({ "WinNew", "WinClosed" }, {
    group = kitty_group,
    desc = "Update Kitty padding on window changes",
    callback = function(args)
        vim.defer_fn(set_kitty_padding, 150)
    end,
})

-- Remove padding on VimLeave
vim.api.nvim_create_autocmd("VimLeave", {
    group = kitty_group,
    desc = "Remove Kitty padding on Vim exit",
    callback = function()
        if vim.env.KITTY_WINDOW_ID ~= nil and vim.env.KITTY_WINDOW_ID ~= "" then
            vim.fn.system("kitty @ set-spacing padding-left=0 2>/dev/null")
        end
    end,
})
