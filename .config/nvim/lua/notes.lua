local plugins = {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    cmd = {
      "ObsidianNew",
      "ObsidianQuickSwitch",
      "ObsidianSearch",
      "ObsidianDailies",
      "ObsidianToday",
      "ObsidianYesterday",
      "ObsidianTomorrow",
      "ObsidianBacklinks",
      "ObsidianLinks",
      "ObsidianTags",
      "ObsidianRename",
    },
    keys = {
      {
        "<leader>oi",
        function()
          vim.cmd("cd " .. vim.fn.expand("~/notes"))
          vim.cmd("edit " .. vim.fn.expand("~/notes/Home.md"))
        end,
        desc = "Open vault index",
      },
      { "<leader>on", ":ObsidianNew<CR>", desc = "New note" },
      { "<leader>oo", ":ObsidianQuickSwitch<CR>", desc = "Quick switch" },
      { "<leader>of", ":ObsidianSearch<CR>", desc = "Search notes" },
      { "<leader>od", ":ObsidianDailies<CR>", desc = "Daily notes" },
      { "<leader>ot", ":ObsidianToday<CR>", desc = "Today's daily note" },
      { "<leader>oy", ":ObsidianYesterday<CR>", desc = "Yesterday's daily note" },
      { "<leader>om", ":ObsidianTomorrow<CR>", desc = "Tomorrow's daily note" },
      { "<leader>ob", ":ObsidianBacklinks<CR>", desc = "Backlinks" },
      { "<leader>ol", ":ObsidianLinks<CR>", desc = "Links in note" },
      { "<leader>oT", ":ObsidianTags<CR>", desc = "Search tags" },
      { "<leader>or", ":ObsidianRename<CR>", desc = "Rename note" },
      { "<leader>oe", ":ObsidianExtractNote<CR>", mode = "v", desc = "Extract to note" },
      { "<leader>ok", ":ObsidianLink<CR>", mode = "v", desc = "Link selection" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "ibhagwan/fzf-lua", opts = {} },
    },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/notes",
        },
      },
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        template = "daily.md",
      },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      completion = {
        nvim_cmp = false,
        min_chars = 2,
      },
      new_notes_location = "current_dir",
      note_id_func = function(title)
        if title ~= nil then
          return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          return tostring(os.time())
        end
      end,
      wiki_link_func = "prepend_note_id",
      preferred_link_style = "wiki",
      -- UI rendering is handled by render-markdown.nvim (avante dependency)
      -- to avoid conflicting conceal/extmarks on checkboxes and other elements.
      ui = { enable = false },
      picker = { name = "fzf-lua" },
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<leader>ox"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },
    },
    config = function(_, opts)
      require("obsidian").setup(opts)
    end,
  },
}

-- Set conceallevel for markdown files in the vault
local group = vim.api.nvim_create_augroup("ObsidianConceal", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  pattern = "*.md",
  callback = function()
    local path = vim.fn.expand("%:p")
    if path:match(vim.fn.expand("~/notes")) then
      vim.opt_local.conceallevel = 2
    end
  end,
})

return plugins
