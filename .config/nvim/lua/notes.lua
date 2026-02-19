local plugins = {
  -- Neorg: Notes, todos, and knowledge management
  {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    dependencies = {
      "benlubas/neorg-interim-ls",
    },
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = "~/notes",
                todos = "~/notes/todos",
                work = "~/notes/work",
              },
              default_workspace = "notes",
              index = "index.norg",
            },
          },
          ["core.completion"] = {
            config = {
              engine = { module_name = "external.lsp-completion" },
            },
          },
          ["core.summary"] = {},
          ["external.interim-ls"] = {
            config = {
              completion_provider = {
                enable = true,
                documentation = true,
                categories = false,
              },
            },
          },
        },
      })

      -- Quick-access keybindings under <leader>o
      vim.keymap.set("n", "<leader>ow", ":Neorg workspace<CR>", { desc = "Switch workspace" })
      vim.keymap.set("n", "<leader>oi", ":Neorg index<CR>", { desc = "Open workspace index" })
      vim.keymap.set("n", "<leader>ojt", ":Neorg journal today<CR>", { desc = "Journal today" })
      vim.keymap.set("n", "<leader>ojy", ":Neorg journal yesterday<CR>", { desc = "Journal yesterday" })
      vim.keymap.set("n", "<leader>ojm", ":Neorg journal tomorrow<CR>", { desc = "Journal tomorrow" })
      vim.keymap.set("n", "<leader>or", ":Neorg return<CR>", { desc = "Return to previous buffer" })
    end,
  },
}

local group = vim.api.nvim_create_augroup("NeorgConceal", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function()
    if vim.bo.filetype == "norg" then
      vim.opt_local.conceallevel = 2
    end
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  group = group,
  callback = function()
    if vim.bo.filetype == "norg" then
      vim.cmd("setlocal conceallevel<")
    end
  end,
})

return plugins
