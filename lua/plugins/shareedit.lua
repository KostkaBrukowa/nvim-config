return {
  {
    "kbwo/vim-shareedit",
    cond = not vim.g.vscode,
    cmd = "ShareEditStart",
    dependencies = {
      "vim-denops/denops.vim",
    },
    config = function()
      -- vim-shareedit shares open files and cursor positions between Neovim and VSCode
      -- Usage: :ShareEditStart in Neovim, then "Connect to vim-shareedit" in VSCode
      -- Requires:
      --   - Deno installed
      --   - VSCode extension: vscode-shareedit (kbwo.shareedit)
    end,
  },
}
