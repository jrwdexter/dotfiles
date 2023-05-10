local term = {}

term.startup = function(use)
  use({ "akinsho/toggleterm.nvim" })
end

term.init = function()
  require("toggleterm").setup{}
  local Terminal  = require('toggleterm.terminal').Terminal

  local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

  function _lazygit_toggle()
    lazygit:toggle()
  end

  vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
end

return term
