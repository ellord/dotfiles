-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
  'lewis6991/gitsigns.nvim',
  dependencies = {
    -- for repeatable_move, so `;`/`,` can repeat hunk jumps
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
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

      -- Navigation between hunks, repeatable with `;`/`,` (mapped in nvim-treesitter.lua)
      local hunk_move = require('nvim-treesitter-textobjects.repeatable_move').make_repeatable_move(function(opts)
        if vim.wo.diff then
          vim.cmd.normal { opts.forward and ']c' or '[c', bang = true }
        else
          gitsigns.nav_hunk(opts.forward and 'next' or 'prev')
        end
      end)

      map('n', ']c', function()
        hunk_move { forward = true }
      end, { desc = 'Jump to next git change' })

      map('n', '[c', function()
        hunk_move { forward = false }
      end, { desc = 'Jump to previous git change' })

      -- Toggle buffer-wide blame view
      map('n', '<leader>gb', function()
        gitsigns.blame_line { full = true }
      end)

      -- You can keep the current line blame toggle if you want
      map('n', '<leader>gB', gitsigns.toggle_current_line_blame)

      map('n', '<leader>gg', ':Gitsigns blame<CR>')
    end,
  },
}
