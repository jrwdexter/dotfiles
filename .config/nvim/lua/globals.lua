local globals = { }

globals.init = function()
  local funcs = {}

  funcs.reload_vimrc = function()
    -- TODO: replace these with some calculated way to unload these packages
    package.loaded['git'] = nil
    package.loaded['globals'] = nil
    package.loaded['hotkeys'] = nil
    package.loaded['ide'] = nil
    package.loaded['language'] = nil
    package.loaded['settings'] = nil
    package.loaded['style'] = nil
    package.loaded['utils'] = nil
    package.loaded['ide.autocomplete'] = nil
    package.loaded['ide.fzf'] = nil
    package.loaded['ide.lsp'] = nil
    package.loaded['ide.run'] = nil
    package.loaded['ide.status'] = nil
    package.loaded['ide.tree'] = nil
    local vimrc = vim.env.MYVIMRC
    dofile(vimrc)

    if vim.g.GuiLoaded then
      local gvimrc = vimrc:gsub('init.lua', 'ginit.lua')
      dofile(gvimrc)
    end
  end

  return funcs
end

return globals
