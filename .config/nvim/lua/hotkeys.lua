-- Clear highlights
vim.keymap.set('n', '//', ':noh<CR>', { desc = "Clear search highlights" })

--************* Navigation *************

-- Pane switching!
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = "Move to left pane" })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = "Move to lower pane" })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = "Move to upper pane" })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = "Move to right pane" })

-- Buffers!
vim.keymap.set('n', '<C-Tab>', ':bnext<CR>', { desc = "Next buffer" })
vim.keymap.set('n', '<C-S-Tab>', ':bprevious<CR>', { desc = "Previous buffer" })

-- Tabs!
vim.keymap.set('n', '<leader>,', ':tabp<CR>', { desc = "Previous tab" })
vim.keymap.set('n', '<leader>.', ':tabn<CR>', { desc = "Next tab" })
vim.keymap.set('n', '<leader>w', ':tabclose<CR>', { desc = "Close tab" })
vim.keymap.set('n', '<leader>n', ':tabnew<CR>', { desc = "New tab" })

vim.keymap.set('', '<C-s>', ':w<CR>', { desc = "Save file" })

-- Calculator
vim.keymap.set('i', '<C-A>', '<C-O>yiW<End>=<C-R>=<C-R>0<CR>', { desc = "Inline calculator" })

-- Vim Editing / Reloading
vim.keymap.set('n', '<leader>ev', ':e $MYVIMRC<cr>', { desc = "Edit init.lua" })
vim.keymap.set('n', '<leader>sv', ":lua Globals.reload_vimrc()<CR>", { silent = true, desc = "Reload config" })
