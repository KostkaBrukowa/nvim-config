return {
    "stevearc/conform.nvim",
  enabled = false,
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
        -- Define formatters by filetype
        formatters_by_ft = {
            javascript = { "prettierd", "prettier", stop_after_first = true },
            typescript = { "prettierd", "prettier", stop_after_first = true },
            javascriptreact = { "prettierd", "prettier", stop_after_first = true },
            typescriptreact = { "prettierd", "prettier", stop_after_first = true },
            json = { "prettierd", "prettier", stop_after_first = true },
            postcss = { "prettierd", "prettier", stop_after_first = true },
            css = { "stylelint" },
            scss = { "stylelint" },
            lua = { "stylua" },
            python = { "black" },
        },
        -- Format on save
        format_on_save = function(bufnr)
            -- Don't format on save for certain buffers
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if bufname:match("^git://") or bufname:match("NvimTree_") then
                return
            end

            return {
                timeout_ms = 10000,
                lsp_format = "fallback",
            }
        end,
        -- Set default format options
        default_format_opts = {
            lsp_format = "fallback",
        },
        -- Customize formatters
        formatters = {
            prettierd = {
                condition = function(self, ctx)
                    return require("utils.file").config_exists({
                        check_package_json = true,
                        config_names = { ".prettierrc*", "prettier.config.*" },
                    })
                end,
            },
            stylua = {
                condition = function(self, ctx)
                    return require("utils.file").config_exists({
                        check_package_json = true,
                        config_names = { "stylua.*" },
                    })
                end,
            },
        },
    },
}
