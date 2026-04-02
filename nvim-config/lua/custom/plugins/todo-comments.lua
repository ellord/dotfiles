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
      keyword = 'bg',
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
    local todo_comments_config = require 'todo-comments.config'

    local function set_mark_highlight_override()
      if vim.o.background ~= 'light' then
        return
      end

      local ok, palettes = pcall(require, 'catppuccin.palettes')
      local colors_ok, colors = pcall(require, 'catppuccin.utils.colors')
      if not ok or not colors_ok then
        return
      end

      local palette = palettes.get_palette()
      vim.api.nvim_set_hl(0, 'TodoBgMARK', {
        bg = colors.darken(palette.teal, 0.12, palette.base),
        fg = palette.teal,
        bold = true,
      })
    end

    local function refresh_todo_comment_highlights()
      if not todo_comments_config.loaded then
        return
      end

      for keyword in pairs(todo_comments_config.options.keywords) do
        vim.api.nvim_set_hl(0, 'TodoBg' .. keyword, {})
        vim.api.nvim_set_hl(0, 'TodoFg' .. keyword, {})
        vim.api.nvim_set_hl(0, 'TodoSign' .. keyword, {})
      end

      todo_comments_config.colors()
      set_mark_highlight_override()
    end

    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('TodoCommentsThemeFix', { clear = true }),
      callback = function()
        vim.defer_fn(refresh_todo_comment_highlights, 20)
      end,
    })

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
