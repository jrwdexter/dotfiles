local plugins = {}
local n=0

for _, t in ipairs(require('ide.tree')) do n=n+1; plugins[n]=t end
for _, t in ipairs(require('ide.status')) do n=n+1; plugins[n]=t end
--for _, t in ipairs(require('ide.autocomplete')) do n=n+1; plugins[n]=t end
--for _, t in ipairs(require('ide.coq')) do n=n+1; plugins[n]=t end
for _, t in ipairs(require('ide.lsp')) do n=n+1; plugins[n]=t end
for _, t in ipairs(require('ide.fzf')) do n=n+1; plugins[n]=t end
for _, t in ipairs(require('ide.copilot')) do n=n+1; plugins[n]=t end
for _, t in ipairs(require('ide.term')) do n=n+1; plugins[n]=t end
for _, t in ipairs(require('ide.gpt')) do n=n+1; plugins[n]=t end

local local_modules = {
  {
    'vim-scripts/DrawIt', config = function()

vim.api.nvim_set_keymap('n', '<localleader>di', ':call DrawIt#DrawItStart()<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<localleader>ds', ':call DrawIt#DrawItStop()<CR>', { noremap = true })
    end
  }
}

for _, t in ipairs(local_modules) do n=n+1; plugins[n]=t end

return plugins
