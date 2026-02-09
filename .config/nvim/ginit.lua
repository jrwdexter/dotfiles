-- Settings
vim.cmd('GuiFont! JetBrainsMono\\ NF:h11')
vim.cmd('GuiPopupmenu 0')

-- Mappings
local vimrc = os.getenv('MYVIMRC')
vim.g.my_gvimrc=vimrc:gsub('init.lua', 'ginit.lua')

vim.keymap.set('n', '<leader>eg', ":execute 'edit' g:my_gvimrc<cr>", { desc = "Edit ginit.lua" })
vim.keymap.set('n', '<leader>sg', ":execute luafile g:my_gvimrc<CR>:filetype detect<CR>:echo 'vimrc reloaded'<CR>", { silent = true, desc = "Reload ginit.lua" })
