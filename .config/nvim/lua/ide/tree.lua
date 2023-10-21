local plugins = {
  {

    "kyazdani42/nvim-tree.lua",
    dependencies = {
      {
        "kyazdani42/nvim-web-devicons", -- File Icons
      },
    },
    config = function()
      require("nvim-tree").setup({
        update_cwd = true,
      })
      vim.api.nvim_set_keymap("n", "<leader>t", ":NvimTreeToggle<CR>", {})
      vim.api.nvim_set_keymap("n", "<leader>f", ":NvimTreeFindFile<CR>", {})
    end,
  },
}
return plugins
