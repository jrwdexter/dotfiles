local utils = {}

utils.startup = function(use)
  use { 'junegunn/vim-easy-align' } -- Easy alignment
  use { 'godlygeek/tabular' } -- Alignment
  use { 'scrooloose/nerdcommenter' } -- Easy commenting
  use { 'tpope/vim-surround' } -- Easy surrounding (and changing of surrounds)
  use { 'moll/vim-bbye' } -- Close buffers
  use { 'mtth/scratch.vim' } --Scratch buffer
end

utils.init = function()
  -- Scratch
  vim.g.scratch_no_mappings = 0
  vim.g.scratch_autohide_insert = 0

  -- bbye! - closing
  vim.api.nvim_set_keymap('n', '<leader>q', ':Bdelete!<CR>', {})

  -- Align
  vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', {})
  vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', {})

  -- Scratch
  vim.api.nvim_set_keymap('n', 'gs', ':Scratch<CR>', { noremap = true })
  vim.api.nvim_set_keymap('n', 'gS', ':ScratchInsert<CR>', { noremap = true })

  -- Autocmd
  vim.api.nvim_command('autocmd FileType scratch map <buffer> <esc><esc> :ScratchPreview<CR>') -- no API for autocommands in lua yet
end

return utils
