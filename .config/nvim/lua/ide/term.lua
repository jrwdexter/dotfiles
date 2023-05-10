local term = {}

term.startup = function(use)
  use({ "akinsho/toggleterm.nvim" })
end

term.init = function()
  require("toggleterm").setup{}
  local Terminal  = require('toggleterm.terminal').Terminal
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
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
    end,
    -- function to run on closing the terminal
    on_close = function(term)
      vim.cmd("startinsert!")
    end,
  })

  function ToggleLazygit()   local cwd = vim.fn.getcwd()
    if cwd ~= cur_cwd then
      cur_cwd = cwd
      lazygit:close()
      lazygit = Terminal:new({ cmd = "lazygit", direction = "float" })
    end
    lazygit:toggle()
  end

  vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua ToggleLazygit()<CR>", {noremap = true, silent = true})
end

return term
