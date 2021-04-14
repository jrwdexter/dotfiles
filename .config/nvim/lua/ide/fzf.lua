local fzf = {}

fzf.startup = function(use)
  -- Searching
  use { 'junegunn/fzf' , run = 'cd ~/.fzf && ./install --all' }
  use { 'junegunn/fzf.vim'}

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }
end

fzf.init = function()
  -- FZF settings
  vim.g.fzf_layout = { down = '~40%' }

  -- FZF
  vim.api.nvim_set_keymap('n', '<C-g>', ':GitFzf<CR>', { noremap = true })
  vim.api.nvim_set_keymap('n', '<C-p>', ':call v:lua.AllFiles()<CR>', { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>b', ':Buffers<CR>', { noremap = true })

  -- Function to use GFiles if in git repo; otherwise, just use Files FZF
  function AllFiles()
    vim.api.nvim_command('silent !git rev-parse --git-dir')
    if not (vim.v.shell_error == 0) then
      --vim.api.nvim_command('Files')
      vim.api.nvim_command('Telescope fd')
    else
      --vim.api.nvim_command('GFiles')
      vim.api.nvim_command('Telescope git_files')
    end
  end

  vim.api.nvim_command([[
  command! -bang -nargs=* Rg
    call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1, <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)
  ]])

  vim.api.nvim_command([[
    command! -bang -nargs=* GitFzf
      call fzf#run({ 'source': 'rg --files --follow --hidden --no-messages -g HEAD '.g:src_dir.' | rg .git.HEAD | sed -E s/..git.HEAD$//', 'sink': 'cd', 'down': '40%' })
  ]])
end

return fzf
