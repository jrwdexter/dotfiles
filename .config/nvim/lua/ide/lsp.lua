local lsp = {}

local function run_command(cmd)
  local proc = io.popen(cmd)
  local result = proc:read('*all')
  local success, _, exit_code = proc:close()
  return result, (success and result ~= ''), exit_code
end

local function find_file(file)
  if vim.fn.executable('which') then
    return run_command('which '..file)
  else
    test = run_command('where '..file..' | head -n 1')
    print(test)
    return test
  end
end

lsp.startup = function(use)
  use { 'neovim/nvim-lspconfig' }
end

lsp.init = function()
  local lspconfig = require('lspconfig')

  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-S-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
      buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end
    if client.resolved_capabilities.document_range_formatting then
      buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    ---- Set autocommands conditional on server_capabilities
    --if client.resolved_capabilities.document_highlight then
      --vim.api.nvim_exec([[
        --hi LspReferenceRead cterm=bold ctermbg=red guibg=DarkGray
        --hi LspReferenceText cterm=bold ctermbg=red guibg=DarkGray
        --hi LspReferenceWrite cterm=bold ctermbg=red guibg=DarkGray
        --augroup lsp_document_highlight
          --autocmd! * <buffer>
          --autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          --autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        --augroup END
      --]], false)
    --end
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  -- LSP: C#
  local omnisharp_bin, success, _ = find_file('omnisharp')
  if success then
    omnisharp_bin = omnisharp_bin:gsub("^%s*(.-)%s*$", "%1") -- trim
    local pid = vim.fn.getpid()
    lspconfig.omnisharp.setup{
      cmd = { omnisharp_bin, '--languageserver', '--hostPID', tostring(pid) },
      on_attach = on_attach,
    }
  end

  -- LSP: Typescript
  require'lspconfig'.tsserver.setup{
    on_attach = on_attach
  }

  -- LSP: CSS
  require'lspconfig'.cssls.setup {
    capabilities = capabilities,
    on_attach = on_attach
  }

  -- LSP: Docker
  require'lspconfig'.dockerls.setup{
    on_attach = on_attach
  }

  -- LSP: PYTHON
  -- Python has an automatic cmd
  lspconfig.pylsp.setup{
    on_attach = on_attach
  }

  -- LSP: LUA
  local sumneko_bin, success, _ = find_file('lua-language-server')
  if success then
    -- TODO: Need to find how to determine where lua-language-server sits
    local sumneko_root_path = '/usr/share/lua-language-server'
    local sumneko_binary    = sumneko_bin

    lspconfig.sumneko_lua.setup {
      cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Setup your lua path
            path = vim.split(package.path, ';'),
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = {
              [vim.fn.expand('$VIMRUNTIME/lua')] = true,
              [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
            },
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
      on_attach = on_attach
    }
  end
end

return lsp
