-- Setup package manager
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

require('settings')
require('hotkeys')

vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Load plugins in a nice way
  require('style').startup(use)
  require('git').startup(use)
  require('language').startup(use)
  require('utils').startup(use)
  require('ide').startup(use)
end)

require('style').init()
require('git').init()
require('language').init()
require('utils').init()
require('ide').init()
globals = require('globals').init()
