local plugins = {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local colors = {
        bg = "#1e222a",
        line_bg = "#1e222a",
        fg = "#D8DEE9",
        fg_green = "#65a380",
        yellow = "#A3BE8C",
        cyan = "#22262C",
        darkblue = "#61afef",
        green = "#BBE67E",
        orange = "#FF8800",
        purple = "#252930",
        magenta = "#c678dd",
        blue = "#22262C",
        red = "#DF8890",
        lightbg = "#282c34",
        nord = "#81A1C1",
        greenYel = "#EBCB8B",
      }

      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
        end,
        hide_in_width = function()
          return vim.fn.winwidth(0) > 80
        end,
        check_git_workspace = function()
          local filepath = vim.fn.expand("%:p:h")
          local gitdir = vim.fn.finddir(".git", filepath .. ";")
          return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
      }

      -- Custom mode component with color
      local mode = {
        function()
          local mode_map = {
            n = "NORMAL",
            i = "INSERT",
            c = "COMMAND",
            V = "VISUAL",
            [""] = "VISUAL",
            v = "VISUAL",
            R = "REPLACE",
          }
          return mode_map[vim.fn.mode()] or vim.fn.mode()
        end,
        color = { fg = colors.bg, bg = colors.red, gui = "bold" },
        padding = { left = 1, right = 1 },
      }

      -- Custom LSP client component
      local lsp_client = {
        function()
          local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
          if #buf_clients == 0 then
            return ""
          end
          local buf_client_names = {}
          for _, client in pairs(buf_clients) do
            if client.name ~= "null-ls" then
              table.insert(buf_client_names, client.name)
            end
          end
          return table.concat(buf_client_names, ", ")
        end,
        icon = "",
        color = { fg = colors.green, bg = colors.line_bg },
      }

      -- Custom file icon component
      local filetype = {
        "filetype",
        colored = true,
        icon_only = false,
        color = { bg = colors.lightbg },
      }

      -- Custom filename component
      local filename = {
        "filename",
        color = { fg = colors.fg, bg = colors.lightbg },
        symbols = {
          modified = " [+]",
          readonly = " []",
        },
      }

      -- Custom filesize component
      local filesize = {
        "filesize",
        color = { fg = colors.fg, bg = colors.lightbg },
        cond = conditions.buffer_not_empty,
      }

      -- Custom diagnostic components
      local diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn" },
        symbols = { error = "  ", warn = "  " },
        diagnostics_color = {
          error = { fg = colors.red, bg = colors.bg },
          warn = { fg = colors.blue, bg = colors.bg },
        },
        colored = true,
        update_in_insert = false,
        always_visible = false,
      }

      -- Custom diff component
      local diff = {
        "diff",
        symbols = { added = "  ", modified = " ", removed = " " },
        diff_color = {
          added = { fg = colors.greenYel, bg = colors.line_bg },
          modified = { fg = colors.orange, bg = colors.line_bg },
          removed = { fg = colors.red, bg = colors.line_bg },
        },
        cond = conditions.hide_in_width,
      }

      -- Custom branch component
      local branch = {
        "branch",
        icon = " ",
        color = { fg = colors.green, bg = colors.line_bg },
      }

      -- Custom progress component
      local progress = {
        "progress",
        color = { fg = colors.bg, bg = colors.fg },
      }

      -- Custom location component
      local location = {
        function()
          local line = vim.fn.line(".")
          local col = vim.fn.col(".")
          return string.format("%d:%d", line, col)
        end,
        color = { fg = colors.bg, bg = colors.fg },
      }

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = {
            normal = {
              a = { fg = colors.bg, bg = colors.nord, gui = "bold" },
              b = { fg = colors.fg, bg = colors.lightbg },
              c = { fg = colors.fg, bg = colors.bg },
            },
            insert = {
              a = { fg = colors.bg, bg = colors.green, gui = "bold" },
            },
            visual = {
              a = { fg = colors.bg, bg = colors.magenta, gui = "bold" },
            },
            replace = {
              a = { fg = colors.bg, bg = colors.red, gui = "bold" },
            },
            inactive = {
              a = { fg = colors.fg, bg = colors.bg },
              b = { fg = colors.fg, bg = colors.bg },
              c = { fg = colors.fg, bg = colors.bg },
            },
          },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = {
            {
              function()
                return " "
              end,
              color = { fg = colors.bg, bg = colors.nord },
              padding = { left = 1, right = 1 },
            },
          },
          lualine_b = {
            filetype,
            filename,
            filesize,
          },
          lualine_c = {
            diff,
            diagnostics,
          },
          lualine_x = {
            lsp_client,
          },
          lualine_y = {
            branch,
          },
          lualine_z = {
            mode,
            progress,
            location,
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },
}

return plugins
