local plugins = {}
local n = 0

for _, t in ipairs(require("ide.ui")) do
  n = n + 1
  plugins[n] = t
end
for _, t in ipairs(require("ide.autocomplete")) do
  n = n + 1
  plugins[n] = t
end
for _, t in ipairs(require("ide.lsp")) do
  n = n + 1
  plugins[n] = t
end
for _, t in ipairs(require("ide.ai")) do
  n = n + 1
  plugins[n] = t
end
for _, t in ipairs(require("ide.term")) do
  n = n + 1
  plugins[n] = t
end
for _, t in ipairs(require("ide.debug")) do
  n = n + 1
  plugins[n] = t
end
for _, t in ipairs(require("ide.whichkey")) do
  n = n + 1
  plugins[n] = t
end

return plugins
