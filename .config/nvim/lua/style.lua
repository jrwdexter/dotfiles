--local paq = require('paq-nvim').paq
local style = {}

style.startup = function(use)
  -- Colors
  use { 'norcalli/nvim-colorizer.lua' }
  use { 'norcalli/nvim-base16.lua' }

  -- Emoji
  use { 'junegunn/vim-emoji' }

  -- Line indentations
  use {"lukas-reineke/indent-blankline.nvim" }
end


style.init = function()
  vim.o.termguicolors=true
  require'colorizer'.setup()

  vim.g.indent_blankline_char='│'

  vim.api.nvim_set_keymap('n', '<leader>co', ':ColorizerToggle<CR>', { })

  local base16 = require 'base16'
  base16(base16.themes.onedark, true)
end

return style
