local plugins = {

  { "tpope/vim-fugitive" }, -- Git utils
  {
    "airblade/vim-gitgutter",
    config = function()
      -- plugin settings
      vim.g.gitgutter_enabled = 1
      vim.g.gitgutter_highlight_lines = 1

      -- mappings
      vim.api.nvim_set_keymap("n", "<leader>gt", ":GitGutterToggle<CR>", {})
      vim.api.nvim_set_keymap(
        "n",
        "<leader>gh",
        ":GitGutterLineHighlightsToggle \\| :GitGutterLineNrHighlightsToggle<CR>",
        {}
      )
    end,
  },
}

return plugins
