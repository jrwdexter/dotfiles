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
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Stop error bells, dammit!
vim.o.vb = true

-- All the settings!
vim.o.magic = true
vim.o.autoindent=true
vim.o.cursorline=false             -- don't show a cursor line
vim.o.autoread=true                  -- reload files when changed on disk, i.e. via `git checkout`
vim.o.backspace='2'                  -- Fix broken backspace in some setups
vim.o.backupcopy='yes'               -- see :help crontab
vim.o.clipboard='unnamedplus'            -- yank and paste with the system clipboard
vim.o.encoding='utf-8'
vim.o.expandtab=true                 -- expand tabs to spaces
vim.o.ignorecase=true                -- case-insensitive search
vim.o.incsearch=true                 -- search as you type
vim.o.laststatus=2                   -- always show statusline
vim.o.list=true                      -- show trailing whitespace
vim.o.listchars='tab:\\t ,trail:▫'    -- characters to utilize during :list command
vim.o.number=true                    -- show line numbers
vim.o.ruler=true                     -- show where you are
vim.o.scrolloff=3                    -- show context above/below cursorline
vim.o.shiftwidth=2                   -- normal mode indentation commands use 2 spaces
vim.o.showcmd=true
vim.o.smartcase=true                 -- case-sensitive search if any caps
vim.o.softtabstop=2                  -- insert mode tab and backspace use 2 spaces
vim.o.tabstop=8                      -- actual tabs occupy 8 characters
vim.o.wildignore='log/**,node_modules/**,target/**,tmp/**,*.rbc'
vim.o.wildmenu=true                  -- show a navigable menu for tab completion
vim.o.hidden=true
vim.o.wildmode='longest,list,full'
vim.o.updatetime=300
vim.o.swapfile=false

vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.o.showbreak=' »'

-- Enable basic mouse behavior such as resizing buffers.
vim.o.mouse='a'

if vim.g.GuiLoaded then
  vim.g.GuiPopupmenu = 0
end
