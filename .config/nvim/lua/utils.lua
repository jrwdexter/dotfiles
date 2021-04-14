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
  vim.api.nvim_set_keymap('', '<leader>l', ':Align<CR>', {})
  vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', {})
  vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', {})

  -- Scratch
  vim.api.nvim_set_keymap('n', 'gs', ':Scratch<CR>', { noremap = true })
  vim.api.nvim_set_keymap('n', 'gS', ':ScratchInsert<CR>', { noremap = true })

  -- Autocmd
  vim.api.nvim_command('autocmd FileType scratch map <buffer> <esc><esc> :ScratchPreview<CR>') -- no API for autocommands in lua yet

  -- #################################
  -- ############ ARCHIVE ############
  -- #################################

  -- helper function to toggle hex mode
  -- function! ToggleHex()
    -- -- hex mode should be considered a read-only operation
    -- -- save values for modified and read-only for restoration later,
    -- -- and clear the read-only flag for now
    -- let l:modified=&mod
    -- let l:oldreadonly=&readonly
    -- let &readonly=0
    -- let l:oldmodifiable=&modifiable
    -- let &modifiable=1
    -- if !exists("b:editHex") || !b:editHex
      -- " save old option s
      -- let b:oldft=&ft
      -- let b:oldbin=&bin
      -- " set new options
      -- setlocal binary " make sure it overrides any textwidth, etc.
      -- silent :e! " this will reload the file without trickeries
                -- "(DOS line endings will be shown entirely )
      -- let &ft="xxd"
      -- " set status
      -- let b:editHex=1
      -- " switch to hex editor
      -- %!xxd
    -- else
      -- " restore old options
      -- let &ft=b:oldft
      -- if !b:oldbin
        -- setlocal nobinary
      -- endif
      -- " set status
      -- let b:editHex=0
      -- " return to normal editing
      -- %!xxd -r
    -- endif
    -- " restore values for modified and read only state
    -- let &mod=l:modified
    -- let &readonly=l:oldreadonly
    -- let &modifiable=l:oldmodifiable
  -- endfunction

  -- -- ex command for toggling hex mode - define mapping if desired
  -- command! -bar Hexmode call ToggleHex()
end

return utils
