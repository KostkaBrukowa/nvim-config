-- Stops continuing comment after 'o'
vim.cmd("autocmd FileType * setlocal formatoptions-=o")
vim.cmd("autocmd FileType toggleterm,NvimTree,fugitive,qf setlocal nospell")
