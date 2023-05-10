local ide = {}

ide.startup = function(use)
  require('ide.tree').startup(use)
  require('ide.status').startup(use)
  require('ide.autocomplete').startup(use)
  require('ide.lsp').startup(use)
  require('ide.fzf').startup(use)
  require('ide.copilot').startup(use)
  require('ide.term').startup(use)

  use { 'vim-scripts/DrawIt' }
end

ide.init = function()
  require('ide.tree').init()
  require('ide.status').init()
  require('ide.fzf').init()
  local capabilities = require('ide.autocomplete').init()
  require('ide.lsp').init()
  require('ide.copilot').init()
  require('ide.term').init()


  vim.api.nvim_set_keymap('n', '<localleader>di', ':call DrawIt#DrawItStart()<CR>', { noremap = true })
  vim.api.nvim_set_keymap('n', '<localleader>ds', ':call DrawIt#DrawItStop()<CR>', { noremap = true })
end

return ide
