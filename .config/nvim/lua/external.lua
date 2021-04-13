local external = {}

external.startup = function(use)
  -- Firefox/Chrome integration
  use { 'glacambre/firenvim' } -- paq { 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } } }
end

external.init = function()
  -- Firefox neovim settings
  vim.g['firenvim_config'] = {
    globalSettings= {},
    localSettings= {}
  }
  fc = vim.g.firenvim_config['localSettings']
  fc['.*'] = "{ 'takeover': 'never' }"
end

return external
