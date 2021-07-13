-- Start dir! - second version is called for command-line vim
if vim.fn.isdirectory("/src") == 1 then
  vim.g.src_dir = "/src"
elseif vim.fn.isdirectory(os.getenv("HOME").."/src") == 1 then
  vim.g.src_dir = os.getenv("HOME").."/src"
elseif vim.fn.isdirectory("/c/src") == 1 then
  vim.g.src_dir = "/c/src"
elseif vim.fn.isdirectory("/mnt/c/src") == 1 then
  vim.g.src_dir = "/mnt/c/src"
end

-- Map leader!
vim.g.mapleader = ','

-- don't highlight current line
-- set nocursorline

-- Stop error bells, dammit!

vim.o.eb = false
vim.o.vb = true
-- vim.o.t_vb=

-- don't bother with vi compatibility
vim.o.cp = false

-- 
-- " All the settings!

-- syntax enable
vim.o.magic = true
vim.o.autoindent=true
vim.o.autoread=true                  -- reload files when changed on disk, i.e. via `git checkout`
vim.o.backspace='2'                  -- Fix broken backspace in some setups
vim.o.backupcopy='yes'               -- see :help crontab
vim.o.clipboard='unnamed'            -- yank and paste with the system clipboard
--vim.o.directory-='.'               -- don't store swapfiles in the current directory
vim.o.encoding='utf-8'
vim.o.expandtab=true                 -- expand tabs to spaces
vim.o.ignorecase=true                -- case-insensitive search
vim.o.incsearch=true                 -- search as you type
vim.o.laststatus=2                   -- always show statusline
vim.o.list=true                      -- show trailing whitespace
vim.o.listchars='tab:\t ,trail:▫'
vim.wo.number=true                   -- show line numbers
vim.o.number=true                    -- show line numbers
vim.o.ruler=true                     -- show where you are
vim.o.scrolloff=3                    -- show context above/below cursorline
vim.o.shiftwidth=2                   -- normal mode indentation commands use 2 spaces
vim.o.showcmd=true
vim.o.smartcase=true                 -- case-sensitive search if any caps
vim.o.softtabstop=2                  -- insert mode tab and backspace use 2 spaces
vim.bo.softtabstop=2                 -- insert mode tab and backspace use 2 spaces
vim.o.tabstop=8                      -- actual tabs occupy 8 characters
vim.o.wildignore='log/**,node_modules/**,target/**,tmp/**,*.rbc'
vim.o.wildmenu=true                  -- show a navigable menu for tab completion
--vim.o.completefunc='emoji#complete'  -- emoji completion
--vim.bo.completefunc='emoji#complete' -- emoji completion
vim.o.hidden=true
vim.o.wildmode='longest,list,full'
vim.o.updatetime=300

vim.o.showbreak=' »'
-- vim.o.filetype='on' -- TO FIX: filetype plugin indent on
-- vim.o['filetype plugin']='on'
-- vim.o.filetype='indent on'
-- filetype plugin indent on

-- Enable basic mouse behavior such as resizing buffers.
vim.o.mouse='a'
if os.getenv('TMUX') and vim.fn.has('nvim') then -- support resizing in tmux
  vim.o.ttymouse='xterm2'
end

if vim.fn.filereadable("/usr/bin/python3") then
  vim.g.python3_host_prog="/usr/bin/python3"
end

if vim.g.GuiLoaded then
  vim.g.GuiPopupmenu = 0
else
  -- Command line version
  -- let $TERM = 'xterm'
  -- vim.o.t_AB="\\e[48;5;%dm"
  -- vim.o.t_AF="\\e[38;5;%dm"
end
