-- Setup package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("globals")
require("settings")

require("lazy").setup({
  spec = {
    { import = "utils" },
    { import = "style" },
    { import = "git" },
    { import = "language" },
    { import = "ide" },
  },
})

vim.keymap.set("n", "<leader>l", ":Lazy<CR>", { silent = true, desc = "Open Lazy" })

require("hotkeys")
