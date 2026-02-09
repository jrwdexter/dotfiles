Globals = {}

Globals.reload_vimrc = function()
  local vimrc = vim.env.MYVIMRC
  dofile(vimrc)

  if vim.g.GuiLoaded then
    local gvimrc = vimrc:gsub("init.lua", "ginit.lua")
    dofile(gvimrc)
  end
end
