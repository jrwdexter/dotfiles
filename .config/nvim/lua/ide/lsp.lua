local lsp = {}

lsp.startup = function(use)
  use { 'ycm-core/YouCompleteMe', run = './install.py' }
  use { 'onsails/lspkind-nvim' } -- Show pictograms next to autocomplete
  -- use { 'neoclide/coc.nvim', 'branch' = 'release' } -- maybe slower completion?
end

lsp.init = function()
  -- YCM settings
  vim.g.ycm_language_server = { 
    {
      name= 'lua',
      cmdline= {
        '/usr/local/lib/luarocks/rocks-5.3/lua-lsp/scm-2/bin/lua-lsp',
        '--stdio'
      },
      filetypes= 'lua',
    }
  }
end

return lsp
