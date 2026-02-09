local plugins = {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      local wk = require("which-key")

      wk.setup({
        preset = "modern",
        delay = 200,
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "+",
          mappings = true,
        },
        win = {
          border = "rounded",
          padding = { 1, 2 },
        },
        layout = {
          height = { min = 4, max = 25 },
          width = { min = 20, max = 50 },
          spacing = 3,
          align = "left",
        },
      })

      -- Register key groups
      wk.add({
        -- Leader key groups
        { "<leader>", group = "Leader" },
        { "<leader>T", group = "Toggle" },
        { "<leader>c", group = "Code/LSP" },
        { "<leader>cw", group = "Workspace" },
        { "<leader>e", group = "Edit config" },
        { "<leader>h", group = "Git hunks" },
        { "<leader>g", group = "Git" },
        { "<leader>s", group = "Source" },
        { "<leader>x", group = "Trouble" },

        -- Top-level mappings with descriptions
        { "//", desc = "Clear search highlights" },
        { "ga", desc = "Easy align" },
        { "gs", desc = "Scratch buffer" },
        { "gS", desc = "Select scratch buffer" },
        { "gd", desc = "Go to definition" },
        { "gD", desc = "Go to declaration" },
        { "gi", desc = "Go to implementation" },
        { "gr", desc = "Go to references" },

        -- Flash
        { "s", desc = "Flash", mode = { "n", "x", "o" } },
        { "S", desc = "Flash Treesitter", mode = { "n", "x", "o" } },

        -- Leader mappings
        { "<leader>l", desc = "Open Lazy" },
        { "<leader>q", desc = "Close buffer" },
        { "<leader>t", desc = "Toggle file explorer" },
        { "<leader>b", desc = "Buffers" },
        { "<leader>/", desc = "Grep" },
        { "<leader>fo", desc = "Format file" },
        { "<leader>u", desc = "Toggle undotree" },
        { "<leader>gg", desc = "Lazygit" },

        -- Config editing
        { "<leader>ev", desc = "Edit init.lua" },
        { "<leader>sv", desc = "Reload config" },

        -- Tabs
        { "<leader>,", desc = "Previous tab" },
        { "<leader>.", desc = "Next tab" },
        { "<leader>w", desc = "Close tab" },
        { "<leader>n", desc = "New tab" },

        -- Toggles
        { "<leader>Tc", desc = "Toggle treesitter context" },
        { "<leader>To", desc = "Toggle colorizer" },

        -- Git toggles
        { "<leader>gt", desc = "Toggle git signs" },
        { "<leader>gh", desc = "Toggle line highlights" },
        { "<leader>gb", desc = "Toggle line blame" },
        { "<leader>gd", desc = "Toggle deleted" },

        -- Git hunks
        { "<leader>hs", desc = "Stage hunk" },
        { "<leader>hr", desc = "Reset hunk" },
        { "<leader>hS", desc = "Stage buffer" },
        { "<leader>hu", desc = "Undo stage hunk" },
        { "<leader>hR", desc = "Reset buffer" },
        { "<leader>hp", desc = "Preview hunk" },
        { "<leader>hb", desc = "Blame line" },
        { "<leader>hd", desc = "Diff this" },
        { "<leader>hD", desc = "Diff this ~" },

        -- Code/LSP (leader c prefix)
        { "<leader>ca", desc = "Code action" },
        { "<leader>cd", desc = "Type definition" },
        { "<leader>ce", desc = "Open diagnostics float" },
        { "<leader>cf", desc = "Format" },
        { "<leader>ci", desc = "Toggle inlay hints" },
        { "<leader>cq", desc = "Set loclist" },
        { "<leader>cr", desc = "Rename" },
        { "<leader>cwa", desc = "Add workspace folder" },
        { "<leader>cwr", desc = "Remove workspace folder" },
        { "<leader>cwl", desc = "List workspace folders" },

        -- Diagnostics navigation
        { "[d", desc = "Previous diagnostic" },
        { "]d", desc = "Next diagnostic" },
        { "[c", desc = "Previous hunk" },
        { "]c", desc = "Next hunk" },

        -- Treesitter textobjects (visual/operator-pending mode)
        { "af", desc = "Around function", mode = { "v", "o" } },
        { "if", desc = "Inside function", mode = { "v", "o" } },
        { "ac", desc = "Around class", mode = { "v", "o" } },
        { "ic", desc = "Inside class", mode = { "v", "o" } },
        { "aa", desc = "Around argument", mode = { "v", "o" } },
        { "ia", desc = "Inside argument", mode = { "v", "o" } },
        { "ai", desc = "Around conditional", mode = { "v", "o" } },
        { "ii", desc = "Inside conditional", mode = { "v", "o" } },
        { "al", desc = "Around loop", mode = { "v", "o" } },
        { "il", desc = "Inside loop", mode = { "v", "o" } },
        { "ab", desc = "Around block", mode = { "v", "o" } },
        { "ib", desc = "Inside block", mode = { "v", "o" } },

        -- Treesitter movements
        { "]m", desc = "Next function start" },
        { "]M", desc = "Next function end" },
        { "[m", desc = "Previous function start" },
        { "[M", desc = "Previous function end" },
        { "]]", desc = "Next class start" },
        { "][", desc = "Next class end" },
        { "[[", desc = "Previous class start" },
        { "[]", desc = "Previous class end" },
        { "]a", desc = "Next argument" },
        { "[a", desc = "Previous argument" },

        -- Treesitter swap
        { "<leader>a", desc = "Swap with next argument" },
        { "<leader>A", desc = "Swap with previous argument" },

        -- Formatting & Linting
        { "<leader>ll", desc = "Trigger linting" },

        -- Repeat moves
        { ";", desc = "Repeat last move (next)" },
        { ",", desc = "Repeat last move (prev)" },
      })
    end,
  },
}

return plugins
