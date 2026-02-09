local plugins = {
  -- snacks.nvim must load early and not be lazy
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          explorer = { hidden = true },
          files = { hidden = true },
          grep = { hidden = true },
          smart = { hidden = true },
        },
      },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      {
        "<C-p>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart Find Files",
      },
      {
        "<C-g>",
        function()
          Snacks.picker.projects({ dev = { vim.g.src_dir }, max_depth = 4 })
        end,
        desc = "Find Git Projects",
      },
      {
        "<leader>b",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>t",
        function()
          Snacks.picker.explorer()
        end,
        desc = "Toggle file explorer",
      },
      {
        "gs",
        function()
          Snacks.scratch()
        end,
        desc = "Scratch buffer",
      },
      {
        "gS",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select scratch buffer",
      },
    },
    init = function()
      vim.api.nvim_create_user_command("Rg", function(opts)
        Snacks.picker.grep({ search = opts.args })
      end, { nargs = "*" })
    end,
  },
}

return plugins
