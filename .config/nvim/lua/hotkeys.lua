-- Clear highlights
vim.api.nvim_set_keymap('n', '//', ':noh<CR>', {})

--************* Navigation *************

-- Pane switching!
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true })

-- Buffers!
vim.api.nvim_set_keymap('n', '<C-Tab>', ':bnext<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-S-Tab>', ':bprevious<CR>', { noremap = true })

-- Tabs!
vim.api.nvim_set_keymap('n', '<leader>,', ':tabp<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>.', ':tabn<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>w', ':tabclose<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>n', ':tabnew<CR>', { noremap = true })

vim.api.nvim_set_keymap('', '<C-s>', ':w<CR>', {})
--vim.api.nvim_set_keymap('', '<F5>', ':make<CR>', {})

-- Calculator
vim.api.nvim_set_keymap('i', '<C-A>', '<C-O>yiW<End>=<C-R>=<C-R>0<CR>', {})

-- Vim Editing / Reloading
vim.api.nvim_set_keymap('n', '<leader>ev', ':e $MYVIMRC<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>eh', ':e C:\\Windows\\System32\\drivers\\etc\\hosts<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sv', ":lua globals.reload_vimrc()<CR>", { noremap = true, silent = true })
