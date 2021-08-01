let nvim_config_path = expand('<sfile>:p:h')
let ginit_path = nvim_config_path . "/ginit.lua"
execute 'luafile '..ginit_path
