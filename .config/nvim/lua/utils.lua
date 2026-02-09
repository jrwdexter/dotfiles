local plugins = {
  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<Plug>(EasyAlign)", mode = "x", desc = "Easy align" },
      { "ga", "<Plug>(EasyAlign)", mode = "n", desc = "Easy align" },
    },
  }, -- Easy alignment
  { "tpope/vim-surround", event = "VeryLazy" }, -- Easy surrounding (and changing of surrounds)
  {
    "folke/flash.nvim",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undotree" },
    },
  },
  {
    "moll/vim-bbye",
    keys = {
      { "<leader>q", ":Bdelete!<CR>", desc = "Close buffer" },
    },
  }, -- Close buffers
}

return plugins
