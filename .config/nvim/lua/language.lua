local plugins = {
  -- Treesitter: Syntax highlighting and code understanding
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          require("nvim-treesitter-textobjects").setup()

          -- Textobject select keymaps
          local select_maps = {
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
          }
          local ts_select = require("nvim-treesitter-textobjects.select")
          for key, opts in pairs(select_maps) do
            vim.keymap.set({ "x", "o" }, key, function()
              ts_select.select_textobject(opts.query, "textobjects")
            end, { desc = opts.desc })
          end

          -- Swap keymaps
          local ts_swap = require("nvim-treesitter-textobjects.swap")
          vim.keymap.set("n", "<leader>a", function()
            ts_swap.swap_next("@parameter.inner")
          end, { desc = "Swap with next argument" })
          vim.keymap.set("n", "<leader>A", function()
            ts_swap.swap_previous("@parameter.inner")
          end, { desc = "Swap with previous argument" })

          -- Move keymaps
          local ts_move = require("nvim-treesitter-textobjects.move")
          local move_maps = {
            ["]m"] = { func = ts_move.goto_next_start, query = "@function.outer", desc = "Next function start" },
            ["]]"] = { func = ts_move.goto_next_start, query = "@class.outer", desc = "Next class start" },
            ["]a"] = { func = ts_move.goto_next_start, query = "@parameter.inner", desc = "Next argument" },
            ["]M"] = { func = ts_move.goto_next_end, query = "@function.outer", desc = "Next function end" },
            ["]["] = { func = ts_move.goto_next_end, query = "@class.outer", desc = "Next class end" },
            ["[m"] = { func = ts_move.goto_previous_start, query = "@function.outer", desc = "Previous function start" },
            ["[["] = { func = ts_move.goto_previous_start, query = "@class.outer", desc = "Previous class start" },
            ["[a"] = { func = ts_move.goto_previous_start, query = "@parameter.inner", desc = "Previous argument" },
            ["[M"] = { func = ts_move.goto_previous_end, query = "@function.outer", desc = "Previous function end" },
            ["[]"] = { func = ts_move.goto_previous_end, query = "@class.outer", desc = "Previous class end" },
          }
          for key, opts in pairs(move_maps) do
            vim.keymap.set({ "n", "x", "o" }, key, function()
              opts.func(opts.query, "textobjects")
            end, { desc = opts.desc })
          end

          -- Enable repeating treesitter moves with ; and ,
          local ok, ts_repeat_move = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
          if ok then
            vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
            vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
          end
        end,
      },
    },
    config = function()
      require("nvim-treesitter").setup()

      -- Ensure parsers are installed
      local ensure_installed = {
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
      }
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyDone",
        once = true,
        callback = function()
          local installed = require("nvim-treesitter").get_installed()
          local to_install = vim.tbl_filter(function(lang)
            return not vim.tbl_contains(installed, lang)
          end, ensure_installed)
          if #to_install > 0 then
            vim.cmd("TSInstall " .. table.concat(to_install, " "))
          end
        end,
      })

      -- Enable treesitter highlighting and indentation
      vim.treesitter.start = vim.treesitter.start or function() end
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
      vim.opt.indentexpr = ""
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
