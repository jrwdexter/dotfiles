-- Settings
vim.api.nvim_command('GuiFont! JetBrainsMono\\ NF:h11')
vim.api.nvim_command('GuiPopupmenu 0')

-- Mappings
local vimrc = os.getenv('MYVIMRC')
vim.g.my_gvimrc=vimrc:gsub('init.lua', 'ginit.lua')

vim.api.nvim_set_keymap('n', '<leader>eg', ":execute 'edit' g:my_gvimrc<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sg', ":execute luafile g:my_gvimrc<CR>:filetype detect<CR>:echo 'vimrc reloaded'<CR>", { noremap = true, silent = true })

-- -- Colors
-- colorscheme dracula
local base16 = require 'base16'
base16(base16.themes.dracula, true)
