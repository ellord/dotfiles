return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  opts = {
    signs = false,
    keywords = {
      MARK = { icon = '󰃀 ', color = 'hint' },
    },
    highlight = {
      pattern = {
        [[.*\W(KEYWORDS)\s*:]],
        [[.*\W(KEYWORDS)\s]],
        [[.*\W(KEYWORDS)$]],
      },
    },
    search = {
      pattern = [[\b(KEYWORDS)(?::|\s|$)]],
    },
  },
  config = function(_, opts)
    require('todo-comments').setup(opts)

    local marks = require 'custom.marks'
    local todo_comments = require 'todo-comments'

    vim.api.nvim_create_user_command('Marks', function()
      marks.open_picker()
    end, { desc = 'Open MARK comments in the current buffer' })

    vim.keymap.set('n', '<leader>sm', marks.open_picker, { desc = '[S]earch [M]ARK comments' })
    vim.keymap.set('n', ']k', function()
      todo_comments.jump_next { keywords = { 'MARK' } }
    end, { desc = 'Next MARK comment' })
    vim.keymap.set('n', '[k', function()
      todo_comments.jump_prev { keywords = { 'MARK' } }
    end, { desc = 'Previous MARK comment' })
  end,
}
