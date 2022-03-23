local tree = {}

tree.startup = function(use)
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons' -- File Icons
    }
  }
end

tree.init = function()
  require'nvim-tree'.setup {
    update_cwd = true
  }
  vim.api.nvim_set_keymap('n', '<leader>t', ':NvimTreeToggle<CR>', {})
  vim.api.nvim_set_keymap('n', '<leader>f', ':NvimTreeFindFile<CR>', {})
end

return tree
