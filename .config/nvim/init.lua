-- Setup package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

require 'globals'
require 'settings'
require 'hotkeys'

require('lazy').setup({
  spec = {
    { import = 'utils'},
    { import = 'style'},
    { import = 'git'},
    { import = 'language'},
    { import = 'ide'},
  }
})

--lazy.setup("utils")
--lazy.setup("style")
--lazy.setup("git")
--lazy.setup("language")
--lazy.setup("ide")

--require('settings')
--require('hotkeys')
--require('globals').init()
