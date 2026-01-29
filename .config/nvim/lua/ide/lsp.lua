local function run_command(cmd)
  local proc = io.popen(cmd)
  local result = proc:read("*all")
  local success, _, exit_code = proc:close()
  return result, (success and result ~= ""), exit_code
end

local function find_file(file)
  if (vim.fn.executable("readlink") ~= 0) and (vim.fn.executable("which") ~= 0) then
    return run_command("readlink -f `which " .. file .. "` | head -n 1")
  elseif vim.fn.executable("which") then
    return run_command("which " .. file)
  end
  return "", false, nil
end

----Fix for not spawning things correctly on windows
--vim.loop.spawn = (function ()
--local spawn = vim.loop.spawn
--return function(path, options, on_exit)
--local full_path = vim.fn.exepath(path)
--return spawn(full_path, options, on_exit)
--end
--end)()

local plugins = {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local coq = require("coq")
      local util = require('lspconfig.util')

      local on_attach = function(client, bufnr)
        local function buf_set_keymap(...)
          vim.api.nvim_buf_set_keymap(bufnr, ...)
        end
        local function buf_set_option(...)
          vim.api.nvim_buf_set_option(bufnr, ...)
        end

        buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Mappings.
        local opts = { noremap = true, silent = true }
        buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
        buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
        buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        buf_set_keymap("n", "<C-S-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        buf_set_keymap("i", "<C-S-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
        buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
        buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
        buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
        buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        buf_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
        buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
        buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
        buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

        -- Set some keybinds conditional on server capabilities
        if client.server_capabilities.document_formatting then
          buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        end
        if client.server_capabilities.document_range_formatting then
          buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
        end
      end

      -- LSP: C#
      local omnisharp_bin, success, _ = find_file("omnisharp")
      if success then
        omnisharp_bin = omnisharp_bin:gsub("^%s*(.-)%s*$", "%1") -- trim
        local util = vim.lsp.util
        local pid = vim.fn.getpid()
        local cmd = {
          omnisharp_bin,
          "-z",
          "--hostPID",
          tostring(pid),
          "--languageserver",
        }

        vim.lsp.config('omnisharp', coq.lsp_ensure_capabilities({
          filetypes = { "cs", "csx", "fs", "fsx", "vb" },
          cmd = cmd,
          on_attach = on_attach,
          root_dir = function(fname)
            local dir = util.root_pattern("*.sln")(fname)
              or util.root_pattern("*.csproj")(fname)
              or util.root_pattern("omnisharp.json")(fname)
            return dir
          end,
        }))
        vim.lsp.enable('omnisharp')
      end

      -- LSP: Typescript
      vim.lsp.config('ts_ls', {
        capabilities = capabilities,
        on_attach = on_attach,
      })
      vim.lsp.enable('ts_ls')

      -- LSP: CSS
      vim.lsp.config('cssls', {
        capabilities = capabilities,
        on_attach = on_attach,
      })
      vim.lsp.enable('cssls')

      -- LSP: Docker
      vim.lsp.config('dockerls', {
        capabilities = capabilities,
        on_attach = on_attach,
        root_dir = util.root_pattern('Dockerfile', '.git'),
      })
      vim.lsp.enable('dockerls')

      -- LSP: PYTHON
      -- Python has an automatic cmd
      vim.lsp.config('pylsp', {
        capabilities = capabilities,
        on_attach = on_attach,
      })
      vim.lsp.enable('pylsp')

      vim.lsp.config('azure_pipelines_ls', {
        settings = {
          yaml = {
            schemas = {
              ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
                "/azure-pipeline*.y*l",
                "/*.azure*",
                "Azure-Pipelines/**/*.y*l",
                "Pipelines/*.y*l",
              },
            },
          },
        },
      })
      vim.lsp.enable('azure_pipelines_ls')

      vim.lsp.config('terraformls', {})
      vim.lsp.enable('terraformls')
      vim.lsp.config('tflint', {})
      vim.lsp.enable('tflint')

      vim.lsp.config('helm_ls', {})
      vim.lsp.enable('helm_ls')

      vim.lsp.config('yamlls', {
        capabilities = capabilities,
        filetypes = { "yaml", "yaml.docker-compose" },
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
            vim.diagnostic.enable(false)
          end
        end,
        settings = {
          cmd = { "yaml-language-server.cmd", "--stdio" },
          yaml = {
            schemas = {
              --["https://json.schemastore.org/chart.json"] = { "/deployment/helm/*", "**/k8s/**.yaml" },
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
                "/azure-pipeline*.y*l",
                "/deploy.y*l",
              },
            },
          },
        },
      })
      vim.lsp.enable('yamlls')

      -- LSP: Haskell
      -- TODO
      local hls_bin, hls_success, _ = find_file("haskell-language-server-wrapper")
      if hls_success then
        vim.lsp.config('hls', {
          on_attach = on_attach,
        })
        vim.lsp.enable('hls')
      end

      -- LSP: Go
      vim.lsp.config('gopls', {})
      vim.lsp.enable('gopls')

      -- LSP: toml
      vim.lsp.config('taplo', {})
      vim.lsp.enable('taplo')
      -- LSP: zizmor
      vim.lsp.config("zizmor", {
        cmd = { "zizmor", "--lsp" },
        filetypes = { "yaml" },
        root_dir = util.root_pattern(".github"),
        single_file_support = true,
      })
      vim.lsp.enable("zizmor")

      -- LSP: LUA
      local luals_bin, lua_success, _ = find_file("lua-language-server")
      if lua_success then
        luals_bin = luals_bin:gsub("%s+$", "")
        local luals_bin_dir, _, _ = run_command("dirname " .. luals_bin)
        luals_bin_dir = luals_bin_dir:gsub("%s+$", "")

        vim.lsp.config('lua_ls', coq.lsp_ensure_capabilities({
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = vim.split(package.path, ";"),
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
              },
              workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
              },
              -- Do not send telemetry data containing a randomized but unique identifier
              telemetry = {
                enable = false,
              },
            },
          },
          on_attach = on_attach,
        }))
        vim.lsp.enable('lua_ls')
      end
    end,
  },
}

return plugins
