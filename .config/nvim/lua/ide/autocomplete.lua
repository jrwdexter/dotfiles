local plugins = {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "moyiz/blink-emoji.nvim",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "none",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      completion = {
        documentation = { auto_show = true },
        accept = { auto_brackets = { enabled = true } },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer", "emoji" },
        providers = {
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = 15, -- Tune by preference
            opts = {
              insert = true, -- Insert emoji (default) or complete its name
              ---@type string|table|fun():table
              trigger = function()
                return { ":" }
              end,
            },
            should_show_items = function()
              return vim.tbl_contains(
                -- Enable emoji completion only for git commits and markdown.
                -- By default, enabled for all file-types.
                { "gitcommit", "markdown" },
                vim.o.filetype
              )
            end,
          },
        },
      },

      cmdline = {
        enabled = true,
        completion = { menu = { auto_show = true } },
      },

      signature = {
        enabled = true,
      },
    },
  },
}

return plugins
