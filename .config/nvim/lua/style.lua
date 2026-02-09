local plugins = {
  -- Colors
  {
    "NvChad/nvim-colorizer.lua",
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer" },
    keys = {
      { "<leader>To", "<cmd>ColorizerToggle<CR>", desc = "Toggle colorizer" },
    },
    opts = {},
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-macchiato")
    end,
  },
  {
    -- I love this theme, but it's pretty much only for vscode/neovim
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = {},
  },
  { "norcalli/nvim-base16.lua", lazy = true },
}

vim.o.termguicolors = true

return plugins
