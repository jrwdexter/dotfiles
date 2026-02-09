local plugins = {
  -- Treesitter: Syntax highlighting and code understanding
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
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
            "vimdoc",
            "todotxt",
            "javascript",
            "typescript",
            "tsx",
            "html",
            "css",
            "c_sharp",
            "cpp",
            "rust",
            "lua",
            "python",
            "yaml",
            "go",
            "markdown",
            "markdown_inline",
          },
          sync_install = false,
          highlight = {
            enable = true,
          },
          indent = { enable = true },

          -- Textobjects configuration
          textobjects = {
            select = {
              enable = true,
              lookahead = true, -- Automatically jump forward to textobj
              keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = { query = "@function.outer", desc = "Select around function" },
                ["if"] = { query = "@function.inner", desc = "Select inside function" },
                ["ac"] = { query = "@class.outer", desc = "Select around class" },
                ["ic"] = { query = "@class.inner", desc = "Select inside class" },
                ["aa"] = { query = "@parameter.outer", desc = "Select around argument" },
                ["ia"] = { query = "@parameter.inner", desc = "Select inside argument" },
                ["ai"] = { query = "@conditional.outer", desc = "Select around conditional" },
                ["ii"] = { query = "@conditional.inner", desc = "Select inside conditional" },
                ["al"] = { query = "@loop.outer", desc = "Select around loop" },
                ["il"] = { query = "@loop.inner", desc = "Select inside loop" },
                ["ab"] = { query = "@block.outer", desc = "Select around block" },
                ["ib"] = { query = "@block.inner", desc = "Select inside block" },
                ["am"] = { query = "@comment.outer", desc = "Select around comment" },
              },
              selection_modes = {
                ["@parameter.outer"] = "v", -- charwise
                ["@function.outer"] = "V", -- linewise
                ["@class.outer"] = "V", -- linewise
              },
              include_surrounding_whitespace = true,
            },

            swap = {
              enable = true,
              swap_next = {
                ["<leader>a"] = { query = "@parameter.inner", desc = "Swap with next argument" },
              },
              swap_previous = {
                ["<leader>A"] = { query = "@parameter.inner", desc = "Swap with previous argument" },
              },
            },

            move = {
              enable = true,
              set_jumps = true, -- Add to jumplist
              goto_next_start = {
                ["]m"] = { query = "@function.outer", desc = "Next function start" },
                ["]]"] = { query = "@class.outer", desc = "Next class start" },
                ["]a"] = { query = "@parameter.inner", desc = "Next argument" },
              },
              goto_next_end = {
                ["]M"] = { query = "@function.outer", desc = "Next function end" },
                ["]["] = { query = "@class.outer", desc = "Next class end" },
              },
              goto_previous_start = {
                ["[m"] = { query = "@function.outer", desc = "Previous function start" },
                ["[["] = { query = "@class.outer", desc = "Previous class start" },
                ["[a"] = { query = "@parameter.inner", desc = "Previous argument" },
              },
              goto_previous_end = {
                ["[M"] = { query = "@function.outer", desc = "Previous function end" },
                ["[]"] = { query = "@class.outer", desc = "Previous class end" },
              },
            },
          },
        })

        -- Enable repeating treesitter moves with ; and ,
        -- Use pcall since module path varies between versions
        local ok, ts_repeat_move = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
        if ok then
          vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
          vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
        end
      end
    end,
  },

  -- Treesitter Context: Sticky header showing current function/class
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesitter-context").setup({
        enable = true,
        max_lines = 3, -- How many lines the window should span (max)
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20, -- Max lines to collapse to a single line
        trim_scope = "outer", -- Which scope to remove first when not enough space
        mode = "cursor", -- 'cursor' or 'topline'
        separator = nil, -- Separator between context and content (nil = no separator)
        zindex = 20, -- z-index of the context window
        on_attach = nil, -- Callback when context attaches to a buffer
      })

      -- Toggle context with a keybinding
      vim.keymap.set("n", "<leader>Tc", function()
        require("treesitter-context").toggle()
      end, { desc = "Toggle treesitter context" })
    end,
  },

  -- Conform.nvim: Modern async formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>fo",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    config = function()
      require("conform").setup({
        -- Define formatters by filetype
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black", "isort" },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          javascriptreact = { "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "prettierd", "prettier", stop_after_first = true },
          json = { "prettierd", "prettier", stop_after_first = true },
          html = { "prettierd", "prettier", stop_after_first = true },
          css = { "prettierd", "prettier", stop_after_first = true },
          yaml = { "prettierd", "prettier", stop_after_first = true },
          markdown = { "prettierd", "prettier", stop_after_first = true },
          go = { "gofmt", "goimports" },
          rust = { "rustfmt" },
          sh = { "shfmt" },
          bash = { "shfmt" },
          terraform = { "terraform_fmt" },
          hcl = { "terraform_fmt" },
          cs = { "csharpier" },
          -- Use LSP formatting as fallback for other filetypes
          ["_"] = { "trim_whitespace" },
        },

        -- Format on save (optional - disabled by default, enable if you want it)
        format_on_save = function(bufnr)
          -- Disable for certain filetypes or large files
          local ignore_filetypes = { "sql", "java" }
          if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
            return
          end
          -- Disable for files larger than 500KB
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          if vim.fn.getfsize(bufname) > 500 * 1024 then
            return
          end
          return { timeout_ms = 500, lsp_fallback = true }
        end,

        -- Customize formatters
        formatters = {
          shfmt = {
            prepend_args = { "-i", "2" }, -- 2 space indentation
          },
        },
      })
    end,
  },

  -- nvim-lint: Async linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        python = { "pylint", "mypy" },
        go = { "golangcilint" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        dockerfile = { "hadolint" },
        yaml = { "yamllint" },
        markdown = { "markdownlint" },
        terraform = { "tflint" },
      }

      -- Create autocommand to trigger linting
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          -- Only lint if the buffer is modifiable and has a filetype
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })

      -- Manual lint trigger
      vim.keymap.set("n", "<leader>ll", function()
        lint.try_lint()
      end, { desc = "Trigger linting" })
    end,
  },

  -- Language-specific plugins
  { "PProvost/vim-ps1", ft = "ps1" },
  { "iamcco/markdown-preview.nvim", build = "cd app && yarn install", ft = "markdown", cmd = "MarkdownPreview" },
  { "hashivim/vim-terraform", ft = { "terraform", "hcl", "tf" } },
  { "dbeniamine/todo.txt-vim", ft = "todo" },
  { "tridactyl/vim-tridactyl", ft = "tridactyl" },
  { "mattn/emmet-vim", ft = { "html", "css", "javascriptreact", "typescriptreact" } },
  { "elkowar/yuck.vim", ft = "yuck" },
}

-- Filetype autocommands
vim.api.nvim_create_augroup("FileTypes", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "FileTypes",
  pattern = { "todo*.txt", "*.todo" },
  callback = function()
    vim.bo.filetype = "todo.txt"
  end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "FileTypes",
  pattern = "*.fdoc",
  callback = function()
    vim.bo.filetype = "yaml"
  end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "FileTypes",
  pattern = "**/k8s/**.yaml",
  callback = function()
    vim.bo.filetype = "helm"
    vim.bo.syntax = "yaml"
  end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "FileTypes",
  pattern = "*.md",
  callback = function()
    vim.bo.filetype = "markdown"
  end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "FileTypes",
  pattern = "*.csx",
  callback = function()
    vim.bo.filetype = "csx"
    vim.bo.syntax = "cs"
  end,
})

return plugins
