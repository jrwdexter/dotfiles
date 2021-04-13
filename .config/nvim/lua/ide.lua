local ide = {}

ide.startup = function(use)
  require('ide.tree').startup(use)
  require('ide.status').startup(use)
  require('ide.lsp').startup(use)
  require('ide.fzf').startup(use)
end

ide.init = function()
  require('ide.tree').init()
  require('ide.status').init()
  require('ide.lsp').init()
  require('ide.fzf').init()
end

return ide
