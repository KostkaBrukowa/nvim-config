return {
    "mfussenegger/nvim-lint",
    enabled = false,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")

        -- Configure linters by filetype
        -- Note: ESLint is handled by none-ls for both diagnostics and code actions
        lint.linters_by_ft = {
            -- javascript = { "eslint_d" },  -- Moved to none-ls
            -- typescript = { "eslint_d" },  -- Moved to none-ls
            -- javascriptreact = { "eslint_d" },  -- Moved to none-ls
            -- typescriptreact = { "eslint_d" },  -- Moved to none-ls
            -- You can add more linters for other filetypes here
            -- python = { "pylint" },
            -- lua = { "luacheck" },
        } -- Create autocommand to run linting on save
        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                -- Don't lint for certain buffers
                local bufname = vim.api.nvim_buf_get_name(0)
                if bufname:match("^git://") or bufname:match("NvimTree_") then
                    return
                end

                lint.try_lint()
            end,
        })
    end,
}
