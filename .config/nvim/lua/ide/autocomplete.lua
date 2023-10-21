local plugins = {
  -----------------
  -- Nice icons
  -----------------
  {
    "onsails/lspkind-nvim",
    config = function()
      require("lspkind").init({
        symbol_map = {
          Text = "",
          Method = "ƒ",
          Function = "",
          Constructor = "",
          Variable = "",
          Class = "",
          Interface = "ﰮ",
          Module = "",
          Property = "",
          Unit = "",
          Value = "",
          Enum = "了",
          Keyword = "",
          Snippet = "﬌",
          Color = "",
          File = "",
          Folder = "",
          EnumMember = "",
          Constant = "",
          Struct = "",
        },
      })
    end,
  }, -- Show pictograms next to autocomplete
  {
    "hrsh7th/cmp-nvim-lsp",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
    end,
  },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      vim.o.completeopt = "menu,menuone,noselect"

      local cmp = require("cmp")

      -- Autocomplete
      -- Better autocomplete menu
      cmp.setup({
        enabled = true,
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          end,
        },
        mapping = {
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<Tab>"] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,

          ["<S-Tab>"] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "emoji" },
          { name = "vsnip" }, -- For vsnip users.
          -- { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
        }, {
          { name = "buffer" },
        }),
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline("/", {
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
  { "hrsh7th/cmp-emoji" },

  ------------------
  -- Autopairs
  ------------------
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt", "vim" },
        enable_check_bracket_line = true,
      })
    end,
  },
}

-----------------
-- Compe
-----------------
-- Setup lspconfig.
---- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
--require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--capabilities = capabilities
--}

--require("nvim-autopairs.completion.compe").setup({
--map_cr = true, --  map <CR> on insert mode
--map_complete = true -- it will auto insert `(` after select function or method item
--})
-- TODO: Update w/ nvim-cmp

---------------------
-- Keyboard functions
---------------------

---- Tab completion
--local t = function(str)
--return vim.api.nvim_replace_termcodes(str, true, true, true)
--end

--local check_back_space = function()
--local col = vim.fn.col('.') - 1
--return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
--end

---- Use (s-)tab to:
---- move to prev/next item in completion menuone
---- jump to prev/next snippet's placeholder
--_G.tab_complete = function()
--if cmp.visible() == 1 then
--print('1')
--return t "<C-n>"
----elseif vim.fn['vsnip#available'](1) == 1 then
----return t "<Plug>(vsnip-expand-or-jump)"
--elseif check_back_space() then
--print('2')
--return t "<Tab>"
--else
--print('3')
--cmp.complete({
--config = {
--sources = {
--{ name = 'nvim_lsp' }
--}
--}
--})
--end
--end
--_G.s_tab_complete = function()
--if cmp.visible() == 1 then
--return t "<C-p>"
----elseif vim.fn['vsnip#jumpable'](-1) == 1 then
----return t "<Plug>(vsnip-jump-prev)"
--else
---- If <S-Tab> is not working in your terminal, change it to <C-h>
--return t "<S-Tab>"
--end
--end

--vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
--vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
--vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
--vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
-- vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", {expr = true})
--vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm(luaeval(\"require 'nvim-autopairs'.autopairs_cr()\"))", {expr = true, silent=true})
--vim.api.nvim_set_keymap("i", "<C-space>", "compe#complete()", {expr = true})

return plugins
