local plugins = {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    config = function()
      local ufo = require("ufo")

      -- Custom virtual text handler
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  ... %d lines "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "Comment" })
        return newVirtText
      end

      -- Provider selector: use LSP with indent fallback by default.
      -- For markdown/shell, prefer treesitter since LSP folds aren't useful.
      -- Indent is the safest fallback (always available, unlike treesitter
      -- which throws UfoFallbackException when no parser is installed).
      local provider_selector = function(_, filetype, _)
        if filetype == "markdown" or filetype == "sh" or filetype == "bash" or filetype == "zsh" then
          return { "treesitter", "indent" }
        end
        return { "lsp", "indent" }
      end

      ufo.setup({
        provider_selector = provider_selector,
        fold_virt_text_handler = handler,
      })

      -- Keybindings
      vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
      vim.keymap.set("n", "zK", function()
        local winid = ufo.peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = "Peek fold or hover" })
    end,
  },
}

return plugins
