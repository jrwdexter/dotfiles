vim.keymap.set("i", "<C-l>", "copilot#Accept()", {
  expr = true,
  silent = true,
  replace_keycodes = false
})

return {
  { "github/copilot.vim" },
}
