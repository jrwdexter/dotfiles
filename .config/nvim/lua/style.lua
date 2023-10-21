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
    "norcalli/nvim-base16.lua",
    config = function()
      local base16 = require("base16")
      base16(base16.themes.onedark, true)
    end,
  },

  -- Emoji
  { "junegunn/vim-emoji" },

  -- Line indentations
  { "lukas-reineke/indent-blankline.nvim" },
}

vim.o.termguicolors = true

vim.g.indent_blankline_char = "│"

return plugins
