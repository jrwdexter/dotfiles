local external = {}

external.startup = function(use)
  -- Firefox/Chrome integration
  use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end } -- paq { 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } } }
end

external.init = function()
  local allSites = '.*'
  -- Firefox neovim settings
  vim.g['firenvim_config'] = {
    globalSettings= {
      alt = 'all'
    },
    localSettings= {
      [allSites] = {
        takeover= 'never'
      }
    }
  }
end

return external
