filetype off

"**************************************
"************** PLUG-VIM  *************
"**************************************
call plug#begin()

" Searching
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Hotkey utils
Plug 'junegunn/vim-easy-align'
Plug 'godlygeek/tabular' " Alignment
" Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'

" Git
Plug 'tpope/vim-fugitive' " Git commands
Plug 'airblade/vim-gitgutter'

" Window + workspace management
Plug 'scrooloose/nerdtree'
Plug 'bling/vim-airline' " Bottom status bar
Plug 'majutsushi/tagbar' " F8 for tagbar toggling
Plug 'moll/vim-bbye' " Close buffers
Plug 'mtth/scratch.vim' "Scratch buffer

" Autocomplete
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }
" Plug 'neoclide/coc.nvim', { 'branch': 'release' } " maybe slower completion?

" Language/syntax tools
Plug 'scrooloose/syntastic'
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript'
Plug 'PProvost/vim-ps1'
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'hashivim/vim-terraform'
Plug 'sbdchd/neoformat'
Plug 'dbeniamine/todo.txt-vim'
Plug 'OrangeT/vim-csharp'
Plug 'tridactyl/vim-tridactyl'
Plug 'mrk21/yaml-vim'

" Colors
" Plug 'altercation/vim-colors-solarized', { 'set': 'all' }
" Plug 'frankier/neovim-colors-solarized-truecolor-only'
Plug 'chrisbra/Colorizer'
Plug 'dracula/vim'

" Firefox/Chrome integration
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

" Emoji
Plug 'junegunn/vim-emoji'

call plug#end()

"**************************************
"**************** SETUP ***************
"**************************************

" Start dir! - second version is called for command-line vim
if isdirectory("/src")
  let g:src_dir = "/src"
elseif isdirectory($HOME . "/src")
  let g:src_dir = $HOME . "/src"
elseif isdirectory("/c/src")
  let g:src_dir = "/c/src"
elseif isdirectory("/mnt/c/src")
  let g:src_dir = "/mnt/c/src"
endif

" don't highlight current line
" set nocursorline

" Stop error bells, dammit!
set noeb vb t_vb=

" Ruby Path
" let g:ruby_path = ":C:\tools\ruby24\bin"

" don't bother with vi compatibility
set nocompatible

" All the settings!
syntax enable
set magic
set autoindent
set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set backspace=2                                              " Fix broken backspace in some setups
set backupcopy=yes                                           " see :help crontab
set clipboard+=unnamed                                       " yank and paste with the system clipboard
set directory-=.                                             " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab                                                " expand tabs to spaces
set ignorecase                                               " case-insensitive search
set incsearch                                                " search as you type
set laststatus=2                                             " always show statusline
set list                                                     " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set number                                                   " show line numbers
set ruler                                                    " show where you are
set scrolloff=3                                              " show context above/below cursorline
set shiftwidth=2                                             " normal mode indentation commands use 2 spaces
set showcmd
set smartcase                                                " case-sensitive search if any caps
set softtabstop=2                                            " insert mode tab and backspace use 2 spaces
set tabstop=8                                                " actual tabs occupy 8 characters
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmenu                                                 " show a navigable menu for tab completion
set completefunc=emoji#complete                              " emoji completion
set hidden
set wildmode=longest,list,full
set updatetime=300

let &showbreak=' »'
filetype plugin indent on

" Enable basic mouse behavior such as resizing buffers.
set mouse=a
if exists('$TMUX') && !has('nvim')  " Support resizing in tmux
  set ttymouse=xterm2
endif

" PLUGIN SETTINGS

if filereadable("/usr/bin/python3")
  let g:python3_host_prog="/usr/bin/python3"
endif

let g:vim_markdown_folding_disabled = 1

" Firefox neovim settings
let g:firenvim_config = {
      \ 'globalSettings': {},
      \ 'localSettings': {}
      \ }
let fc = g:firenvim_config['localSettings']
let fc['.*'] = { 'takeover': 'never' }

" FZF settings
let g:fzf_layout = { 'down': '~40%' }

" YCM settings
let g:ycm_language_server =
  \ [
  \   {
  \     'name': 'lua',
  \     'cmdline': [ '/usr/local/lib/luarocks/rocks-5.3/lua-lsp/scm-2/bin/lua-lsp', '--stdio' ],
  \     'filetypes': [ 'lua' ]
  \   }
  \ ]

" Scratch
let g:scratch_no_mappings = 0
let g:scratch_autohide_insert = 0

"**************************************
"************** MAPPINGS **************
"**************************************

" Map leader!
let mapleader = ','

"************ C# shortcuts ************
" All C# shortcuts begin with i, e, or s.
" This is to differentiate from generic VIM shortcuts, which will not use these prefixs.
"
" Insert Enumerable
nnoremap <leader>ie ciWIEnumerable<<esc>pa><esc>B
"Insert generic to parameter
nnoremap <leader>ig ciW<<esc>pa><esc>Bi
" Un-generic an item
nnoremap <leader>dg l?[^a-zA-Z_<>]<CR>ld/<<CR>xEx
" Remove parameter
nnoremap <leader>dp ?,\|(<CR>ld/,\|)<CR>V:s/\((\),\|,\(,\)\|,\()\)/\1\2\3/g<CR>
" Split up constructor on to multiple lines
nnoremap <leader>si ^V:s/\(,\|{\)/\1\r    /g<cr>V:s/\({\)/\r\1/g<cr>
" Rejoin constructor
nnoremap <leader>sj ?(<CR>v/)<CR>:s/\n//g<CR>
" Brackets and Try/Catch
nnoremap <leader>ib O{<esc>jo}<esc>k^
nnoremap <leader>it Otry<cr>{<esc>jo}<cr>catch(Exception ex)<cr>{<cr><cr>}<esc>kkk/Exception<cr>
vnoremap <leader>ib <esc>`<O{<esc>`>o}<esc>
vnoremap <leader>it <esc>`<Otry<cr>{<esc>`>o}<cr>catch(Exception ex)<cr>{<cr><cr>}<esc>kkk/Exception<cr>
nmap <leader>D <plug>(YCMHover)

"**************************************
"*********** VIM Shortcuts ************
"**************************************

" Formatting!
nnoremap <leader>fo :Neoformat<CR>

" Clear highlights
nmap <esc><esc> :noh<CR>

"************* Navigation *************

" Pane switching!
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Buffers!
nnoremap <C-Tab> :bnext<CR>
nnoremap <C-S-Tab> :bprevious<CR>

" Tabs!
nnoremap <leader>, :tabp<CR>
nnoremap <leader>. :tabn<CR>
nnoremap <leader>w :tabclose<CR>
nnoremap <leader>n :tabnew<CR>

map <C-s> :w<CR>
map <F5> :make<CR>
map <leader>l :Align<CR>
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
nnoremap gs :Scratch<CR>
nnoremap gS :ScratchInsert<CR>
autocmd FileType scratch map <buffer> <esc><esc> :ScratchPreview<CR>


"*************** Plugins **************

" FZF
noremap <C-g> :GitFzf<CR>
noremap <C-p> :call AllFiles()<CR>
noremap <leader>b :Buffers<CR>

" Tagbar BROKEN
nmap <F8> :TagbarToggle<CR>

" NERDTree!
nmap <leader>t :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>

" BROKEN + duplicate
nmap <leader>] :TagbarToggle<CR>

" BROKEN
nmap <leader><space> :call whitespace#strip_trailing()<CR>

nmap <leader>g :GitGutterToggle<CR>

" kwbd! - closing
nmap <leader>q :Bdelete!<CR>

" Neoformat
autocmd FileType javascript setlocal formatprg=prettier
autocmd FileType lua setlocal formatprg=luarocks
let g:neoformat_try_formatprg = 1

"*************** Macros ***************

" Calculator
ino <C-A> <C-O>yiW<End>=<C-R>=<C-R>0<CR>

" VsVim replace in tag functionality
" nnoremap cit /><cr>?<[^/]<cr>/><cr>c/<<cr>>
" nnoremap dit /><cr>?<[^/]<cr>/><cr>c/<<cr>><esc>

" VsVim replace in tag functionality
nnoremap cat /><cr>?<[^/]<cr>v/><cr>/><cr>c
nnoremap dat /><cr>?<[^/]<cr>v/><cr>/><cr>d

" Vim Editing / Reloading
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>eh :e C:\Windows\System32\drivers\etc\hosts<cr>
nnoremap <silent> <leader>sv :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" plugin settings
let g:NERDSpaceDelims=1
let g:gitgutter_enabled = 1
let g:gitgutter_highlight_lines=1
let g:ctrlp_working_path_mode = 'ra'

" ZOMG the_silver_searcher is so much faster than ack"
let g:ackprg = 'ag --nogroup --column'

augroup FileTypes
  " todo.txt
  autocmd!
  autocmd BufRead,BufNewFile todo*.txt set set filetype=todo.txt
  autocmd BufRead,BufNewFile *.todo set filetype=todo.txt
  " fdoc is yaml
  autocmd BufRead,BufNewFile *.fdoc set filetype=yaml
  " md is markdown
  autocmd BufRead,BufNewFile *.md set filetype=markdown
augroup END

" #################################
" ###### PERSONAL FUNCTIONS #######
" #################################

if exists('g:GuiLoaded')
  GuiPopupmenu 0
else
  " Command line version
  " let $TERM = 'xterm'
  let &t_AB="\e[48;5;%dm"
  let &t_AF="\e[38;5;%dm"
endif

" Function to use GFiles if in git repo; otherwise, just use Files FZF
function AllFiles()
  let a = system("git rev-parse --git-dir 2> /dev/null")
  if v:shell_error != 0
    :Files
  else
    :GFiles
  endif
endfunction

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=* GitFzf
  \ call fzf#run({
  \   'source': 'rg --files --hidden --no-messages -g HEAD '.g:src_dir.' | rg .git.HEAD | sed -E s/..git.HEAD$//',
  \   'sink': 'cd',
  \   'down': '40%' })

" #################################
" ############ ARCHIVE ############
" #################################

" helper function to toggle hex mode
function! ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old option s
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    silent :e! " this will reload the file without trickeries 
              "(DOS line endings will be shown entirely )
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

" ex command for toggling hex mode - define mapping if desired
command! -bar Hexmode call ToggleHex()
