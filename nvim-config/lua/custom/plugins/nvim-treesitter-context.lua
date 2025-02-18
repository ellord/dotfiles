return {
  'nvim-treesitter/nvim-treesitter-context',
  event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
  enabled = true,
  opts = { mode = 'cursor', max_lines = 3, separator = nil },
  keys = {
    {
      '<leader>ut',
      function()
        local Util = require 'lazyvim.util'
        local tsc = require 'treesitter-context'
        tsc.toggle()
        if Util.inject.get_upvalue(tsc.toggle, 'enabled') then
          Util.info('Enabled Treesitter Context', { title = 'Option' })
        else
          Util.warn('Disabled Treesitter Context', { title = 'Option' })
        end
      end,
      desc = 'Toggle Treesitter Context',
    },
  },
  config = function()
    vim.cmd [[hi TreesitterContextBottom gui=NONE]]
  end,
}
