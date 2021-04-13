local tree = {}

tree.startup = function(use)
  use { 'kyazdani42/nvim-web-devicons' } -- File Icons
  use { 'kyazdani42/nvim-tree.lua' }
end

tree.init = function()
  vim.api.nvim_set_keymap('n', '<leader>t', ':NvimTreeToggle<CR>', {})
  vim.api.nvim_set_keymap('n', '<leader>f', ':NvimTreeFindFile<CR>', {})
end

return tree
