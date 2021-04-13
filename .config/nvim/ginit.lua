-- Settings
vim.api.nvim_command('GuiFont! JetBrains\\ Mono:h11')
vim.api.nvim_command('GuiPopupmenu 0')

-- Mappings
-- vim.g.my_gvimrc=substitute($MYVIMRC, 'init.vim$', 'ginit.vim', 'g')

-- nnoremap <leader>eg :execute 'edit' g:my_gvimrc<CR>
-- nnoremap <leader>sg :execute 'source' g:my_gvimrc<CR>

-- -- Colors
-- colorscheme dracula
local base16 = require 'base16'
base16(base16.themes.dracula, true)
