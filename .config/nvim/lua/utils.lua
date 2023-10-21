local plugins = {
  {
    "junegunn/vim-easy-align",
    config = function()
      -- Align
      vim.api.nvim_set_keymap("x", "ga", "<Plug>(EasyAlign)", {})
      vim.api.nvim_set_keymap("n", "ga", "<Plug>(EasyAlign)", {})
    end,
  }, -- Easy alignment
  { "godlygeek/tabular" }, -- Alignment
  { "scrooloose/nerdcommenter" }, -- Easy commenting
  { "tpope/vim-surround" }, -- Easy surrounding (and changing of surrounds)
  {
    "moll/vim-bbye",
    config = function()
      -- bbye! - closing
      vim.api.nvim_set_keymap("n", "<leader>q", ":Bdelete!<CR>", {})
    end,
  }, -- Close buffers
  {
    "mtth/scratch.vim",
    config = function()
      -- Scratch
      vim.g.scratch_no_mappings = 0
      vim.g.scratch_autohide_insert = 0

      -- Scratch
      vim.api.nvim_set_keymap("n", "gs", ":Scratch<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "gS", ":ScratchInsert<CR>", { noremap = true })

      -- Autocmd
      vim.api.nvim_command("autocmd FileType scratch map <buffer> <esc><esc> :ScratchPreview<CR>") -- no API for autocommands in lua yet
    end,
  }, --Scratch buffer
}

return plugins
