local lsp = {}

local function run_command(cmd)
  local proc = io.popen(cmd)
  local result = proc:read('*all')
  local success, _, exit_code = proc:close()
  return result, success, exit_code
end

lsp.startup = function(use)
  use { 'neovim/nvim-lspconfig' }
  use { 'onsails/lspkind-nvim' } -- Show pictograms next to autocomplete
  use { 'hrsh7th/nvim-compe' }
  use { 'windwp/nvim-autopairs' }
end

lsp.init = function()
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    --buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

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

  local lspconfig = require('lspconfig')

  -- LSP: C#
  local omnisharp_bin, success, _ = run_command('which omnisharp')
  if success then
    omnisharp_bin = omnisharp_bin:gsub("^%s*(.-)%s*$", "%1") -- trim
    local pid = vim.fn.getpid()
    lspconfig.omnisharp.setup{
      cmd = { omnisharp_bin, '--languageserver', '--hostPID', tostring(pid) },
      on_attach = on_attach,
    }
  end

  -- LSP: PYTHON
  -- Python has an automatic cmd
  lspconfig.pyls.setup{
    on_attach = on_attach
  }

  -- LSP: LUA
  local sumneko_bin, success, _ = run_command('which lua-language-server')
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

  -- Nice icons
  require('lspkind').init({
     with_text = true,
     symbol_map = {
       Text = '',
       Method = 'ƒ',
       Function = '',
       Constructor = '',
       Variable = '',
       Class = '',
       Interface = 'ﰮ',
       Module = '',
       Property = '',
       Unit = '',
       Value = '',
       Enum = '了',
       Keyword = '',
       Snippet = '﬌',
       Color = '',
       File = '',
       Folder = '',
       EnumMember = '',
       Constant = '',
       Struct = ''
     },
  })

  vim.o.completeopt = "menuone,noselect"

  -- Better autocomplete menu
  require "compe".setup {
      enabled = true,
      autocomplete = true,
      debug = false,
      min_length = 1,
      preselect = "enable",
      throttle_time = 80,
      source_timeout = 200,
      incomplete_delay = 400,
      max_abbr_width = 100,
      max_kind_width = 100,
      max_menu_width = 100,
      documentation = true,
      source = {
          path = true,
          buffer = true,
          calc = true,
          vsnip = true,
          nvim_lsp = true,
          nvim_lua = true,
          spell = true,
          tags = true,
          snippets_nvim = true,
          treesitter = true
      }
  }

  local t = function(str)
      return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  local check_back_space = function()
      local col = vim.fn.col(".") - 1
      if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
          return true
      else
          return false
      end
  end

  -- tab completion

  _G.tab_complete = function()
      if vim.fn.pumvisible() == 1 then
          return t "<C-n>"
      elseif check_back_space() then
          return t "<Tab>"
      else
          return vim.fn["compe#complete"]()
      end
  end
  
  _G.s_tab_complete = function()
      if vim.fn.pumvisible() == 1 then
          return t "<C-p>"
      elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
          return t "<Plug>(vsnip-jump-prev)"
      else
          return t "<S-Tab>"
      end
  end

  --  mappings
  vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

  function _G.completions()
      local npairs = require("nvim-autopairs")
      if vim.fn.pumvisible() == 1 then
          if vim.fn.complete_info()["selected"] ~= -1 then
              return vim.fn["compe#confirm"]("<CR>")
          end
      end
      return npairs.check_break_line_char()
  end

  vim.api.nvim_set_keymap("i", "<CR>", "v:lua.completions()", {expr = true})
end

return lsp
