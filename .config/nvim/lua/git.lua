local git = {}

git.startup = function(use)
  use { 'tpope/vim-fugitive' } -- Git utils
  use { 'airblade/vim-gitgutter' }
end

git.init = function()
  -- plugin settings
  vim.g.gitgutter_enabled = 1
  vim.g.gitgutter_highlight_lines=1

  -- mappings
  vim.api.nvim_set_keymap('n', '<leader>gt', ':GitGutterToggle<CR>', {})
  vim.api.nvim_set_keymap('n', '<leader>gh', ':GitGutterLineHighlightsToggle \\| :GitGutterLineNrHighlightsToggle<CR>', {})
end

return git
