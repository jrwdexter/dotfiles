local plugins = {
  -- Mason: LSP/DAP/Linter/Formatter installer
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- Bridge between mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        -- Servers to automatically install
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "cssls",
          "dockerls",
          "pylsp",
          "terraformls",
          "tflint",
          "helm_ls",
          "yamlls",
          "gopls",
          "taplo",
          "omnisharp",
        },
        -- Auto-install servers configured via lspconfig
        automatic_installation = true,
      })
    end,
  },

  -- LSP Configuration using native Neovim 0.11+ API
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      -- Common on_attach function for all LSP servers
      local on_attach = function(client, bufnr)
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Mappings
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-S-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("i", "<C-S-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>cwa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<leader>cwr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<leader>cwl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "<leader>cd", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>ce", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1 })
        end, opts)
        vim.keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1 })
        end, opts)
        vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, opts)

        -- Formatting keybinds
        if client.server_capabilities.documentFormattingProvider then
          vim.keymap.set("n", "<leader>cf", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end
        if client.server_capabilities.documentRangeFormattingProvider then
          vim.keymap.set("v", "<leader>cf", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end

        -- Inlay hints (Neovim 0.10+)
        if vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          vim.keymap.set("n", "<leader>ci", function()
            vim.lsp.inlay_hint.enable(
              not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
              { bufnr = bufnr }
            )
          end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))
        end
      end

      -- Capabilities enhanced by blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Helper to find root directory
      -- Neovim 0.11+ root_dir receives (bufnr, on_dir) and must call on_dir()
      local function root_pattern(...)
        local patterns = { ... }
        return function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          for _, pattern in ipairs(patterns) do
            local match = vim.fs.find(pattern, {
              path = vim.fs.dirname(fname),
              upward = true,
              type = pattern:match("%.") and "file" or "directory",
            })[1]
            if match then
              on_dir(vim.fs.dirname(match))
              return
            end
          end
          on_dir(vim.fs.dirname(fname))
        end
      end

      -- Server configurations using vim.lsp.config (Neovim 0.11+)
      local servers = {
        -- TypeScript/JavaScript
        ts_ls = {
          on_attach = on_attach,
          capabilities = capabilities,
        },

        -- CSS
        cssls = {
          on_attach = on_attach,
          capabilities = capabilities,
        },

        -- Docker
        dockerls = {
          on_attach = on_attach,
          capabilities = capabilities,
          root_dir = root_pattern("Dockerfile", ".git"),
        },

        -- Python
        pylsp = {
          on_attach = on_attach,
          capabilities = capabilities,
        },

        -- Terraform
        terraformls = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
        tflint = {
          on_attach = on_attach,
          capabilities = capabilities,
        },

        -- Helm
        helm_ls = {
          on_attach = on_attach,
          capabilities = capabilities,
        },

        -- YAML
        yamlls = {
          filetypes = { "yaml", "yaml.docker-compose" },
          on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
              vim.diagnostic.enable(false, { bufnr = bufnr })
            end
          end,
          capabilities = capabilities,
          settings = {
            yaml = {
              schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
                  "/azure-pipeline*.y*l",
                  "/deploy.y*l",
                },
              },
            },
          },
        },

        -- Go
        gopls = {
          on_attach = on_attach,
          capabilities = capabilities,
        },

        -- TOML
        taplo = {
          on_attach = on_attach,
          capabilities = capabilities,
        },

        -- C#
        omnisharp = {
          on_attach = on_attach,
          capabilities = capabilities,
        },

        -- Lua
        lua_ls = {
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
      }

      -- Configure and enable servers using native vim.lsp API
      for server, config in pairs(servers) do
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      -- Manual server configurations (not managed by Mason)

      -- Haskell Language Server - requires manual installation
      local hls_bin = vim.fn.exepath("haskell-language-server-wrapper")
      if hls_bin ~= "" then
        vim.lsp.config("hls", {
          on_attach = on_attach,
          capabilities = capabilities,
        })
        vim.lsp.enable("hls")
      end

      -- Zizmor (GitHub Actions linter) - custom server definition
      local zizmor_bin = vim.fn.exepath("zizmor")
      if zizmor_bin ~= "" then
        vim.lsp.config("zizmor", {
          cmd = { "zizmor", "--lsp" },
          filetypes = { "yaml" },
          root_dir = root_pattern(".github"),
          single_file_support = true,
          on_attach = on_attach,
          capabilities = capabilities,
        })
        vim.lsp.enable("zizmor")
      end
    end,
  },
}

return plugins
