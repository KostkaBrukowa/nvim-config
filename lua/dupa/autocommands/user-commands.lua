vim.api.nvim_create_user_command("Eslint", function()
    vim.cmd("compiler eslint | make ./ | copen")
end, {})

vim.api.nvim_create_user_command("EslintPanel", function()
    vim.cmd(
        "compiler jest | make --selectProjects lint --silent --reporters=jest-silent-reporter | copen"
    )
end, {})

vim.api.nvim_create_user_command("JestPanel", function()
    vim.cmd("compiler jest | make --selectProjects test | copen")
end, {})

vim.api.nvim_create_user_command("Jest", function()
    vim.cmd("compiler jest | make | copen")
end, {})
