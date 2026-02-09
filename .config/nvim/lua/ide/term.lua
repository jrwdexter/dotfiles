local plugins = {
  {

    {
      "akinsho/toggleterm.nvim",
      keys = {
        { "<leader>gg", desc = "Lazygit" },
      },
      config = function()
        require("toggleterm").setup({})
        local Terminal = require("toggleterm.terminal").Terminal
        local cur_cwd = vim.fn.getcwd()

        local lazygit = Terminal:new({
          cmd = "lazygit",
          dir = "git_dir",
          direction = "float",
          float_opts = {
            border = "double",
          },
          -- function to run on opening the terminal
          on_open = function(term)
            vim.cmd("startinsert!")
            vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = term.bufnr, silent = true, desc = "Close lazygit" })
          end,
          -- function to run on closing the terminal
          on_close = function()
            vim.cmd("startinsert!")
          end,
        })

        local function toggle_lazygit()
          local cwd = vim.fn.getcwd()
          if cwd ~= cur_cwd then
            cur_cwd = cwd
            lazygit:close()
            lazygit = Terminal:new({ cmd = "lazygit", direction = "float" })
          end
          lazygit:toggle()
        end

        vim.keymap.set("n", "<leader>gg", toggle_lazygit, { silent = true, desc = "Lazygit" })
      end,
    },
  },
}

return plugins
