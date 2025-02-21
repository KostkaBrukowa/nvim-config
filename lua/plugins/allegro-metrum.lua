return {
  "git@github.com:allegro-internal/vscode-allegro-metrum",
  build = "npm ci --quiet && npm ci --prefix ./server --quiet && npm run build",
  cond = not vim.g.vscode,
}
