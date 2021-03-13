" Settings
GuiFont! JetBrains\ Mono:h11
GuiPopupmenu 0

" Mappings
let g:my_gvimrc=substitute($MYVIMRC, 'init.vim$', 'ginit.vim', 'g')

nnoremap <leader>eg :execute 'edit' g:my_gvimrc<CR>
nnoremap <leader>sg :execute 'source' g:my_gvimrc<CR>

" Colors
colorscheme dracula
