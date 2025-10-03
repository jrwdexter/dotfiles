local plugins = {
  -- Colors
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      --require'colorizer'.setup() -- remove me?

      vim.api.nvim_set_keymap("n", "<leader>co", ":ColorizerToggle<CR>", {})
    end,
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
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "norcalli/nvim-base16.lua",
    --config = function()
    --local base16 = require("base16")
    --base16(base16.themes.dracula, true)
    --base16(base16.themes['gruvbox-dark-hard'], true)
    --end,
  },

  -- Emoji
  { "junegunn/vim-emoji" },

  -- Line indentations
  { "lukas-reineke/indent-blankline.nvim" },
}

vim.o.termguicolors = true

vim.g.indent_blankline_char = "│"

return plugins
