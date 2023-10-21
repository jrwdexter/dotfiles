local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ts_config = require("nvim-treesitter.configs")

      if ts_config then
        ts_config.setup({
          ensure_installed = {
            "bash",
            "dockerfile",
            "hcl",
            "json",
            "regex",
            "vim",
            "todotxt",
            "javascript",
            "typescript",
            "html",
            "css",
            "c_sharp",
            "cpp",
            "rust",
            "lua",
            "python",
            "yaml",
          },
          sync_install = false,
          highlight = {
            enable = true,
            use_languagetree = true,
          },
          indent = { enable = true },
        })
      end
    end,
  },
  { "PProvost/vim-ps1" },
  {
    "plasticboy/vim-markdown",
    config = function()
      vim.g.vim_markdown_folding_disabled = 1
    end,
  },
  { "iamcco/markdown-preview.nvim", run = "cd app && yarn install" },
  { "hashivim/vim-terraform" },
  {
    "sbdchd/neoformat",
    config = function()
      -- Formatting!
      vim.api.nvim_set_keymap("n", "<leader>fo", ":Neoformat<CR>", { noremap = true })

      -- Neoformat
      vim.api.nvim_command("autocmd FileType lua setlocal formatprg=luaformatter")
      vim.g.neoformat_try_formatprg = 1

      vim.cmd([[augroup FileTypes
    " todo.txt
    autocmd!
    autocmd BufRead,BufNewFile todo*.txt set filetype=todo.txt
    autocmd BufRead,BufNewFile *.todo set filetype=todo.txt
    " fdoc is yaml
    autocmd BufRead,BufNewFile *.fdoc set filetype=yaml
    " helm is yaml
    autocmd BufRead,BufNewFile **/k8s/**.yaml set filetype=helm syntax=yaml
    " md is markdown
    autocmd BufRead,BufNewFile *.md set filetype=markdown
    " csx
    autocmd BufRead,BufNewFile *.csx set filetype=csx syntax=cs
  augroup END]])
    end,
  },
  { "dbeniamine/todo.txt-vim" },
  { "tridactyl/vim-tridactyl" },
  { "mrk21/yaml-vim" },
  { "mattn/emmet-vim" },
}

--************ C# shortcuts ************
-- All C# shortcuts begin with i, e, or s.
-- This is to differentiate from generic VIM shortcuts, which will not use these prefixs.

-- Insert Enumerable
vim.api.nvim_set_keymap("n", "<leader>ie", "ciWIEnumerable<<esc>pa><esc>B", { noremap = true })
--Insert generic to parameter
vim.api.nvim_set_keymap("n", "<leader>ig", "ciW<<esc>pa><esc>Bi", { noremap = true })
-- Un-generic an item
vim.api.nvim_set_keymap("n", "<leader>dg", "l?[^a-zA-Z_<>]<CR>ld/<<CR>xEx", { noremap = true })
-- Remove parameter
vim.api.nvim_set_keymap(
  "n",
  "<leader>dp",
  "?,\\|(<CR>ld/,\\|)<CR>V:s/\\((\\),\\|,\\(,\\)\\|,\\()\\)/\\1\\2\\3/g<CR>",
  { noremap = true }
)
-- Split up constructor on to multiple lines
vim.api.nvim_set_keymap(
  "n",
  "<leader>si",
  "^V:s/\\(,\\|{\\)/\\1\\r    /g<cr>V:s/\\({\\)/\\r\\1/g<cr>",
  { noremap = true }
)
-- Rejoin constructor
vim.api.nvim_set_keymap("n", "<leader>sj", "?(<CR>v/)<CR>:s/\\n//g<CR>", { noremap = true })
-- Brackets and Try/Catch
vim.api.nvim_set_keymap("n", "<leader>ib", "O{<esc>jo}<esc>k^", { noremap = true })
vim.api.nvim_set_keymap(
  "n",
  "<leader>it",
  "Otry<cr>{<esc>jo}<cr>catch(Exception ex)<cr>{<cr><cr>}<esc>kkk/Exception<cr>",
  { noremap = true }
)
vim.api.nvim_set_keymap("v", "<leader>ib", "<esc>`<O{<esc>`>o}<esc>", { noremap = true })
vim.api.nvim_set_keymap(
  "v",
  "<leader>it",
  "<esc>`<Otry<cr>{<esc>`>o}<cr>catch(Exception ex)<cr>{<cr><cr>}<esc>kkk/Exception<cr>",
  { noremap = true }
)

return plugins
