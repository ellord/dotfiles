-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    current_line_blame = true,
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Toggle buffer-wide blame view
      map('n', '<leader>gb', function()
        gitsigns.blame_line { full = true }
      end)

      -- You can keep the current line blame toggle if you want
      map('n', '<leader>gB', gitsigns.toggle_current_line_blame)

      map('n', '<leader>gg', ':Gitsigns blame<CR>')

      -- Add more keymaps here as needed
    end,
  },
}
