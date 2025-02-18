return {
  'f-person/auto-dark-mode.nvim',
  opts = {
    update_interval = 1000,
    set_dark_mode = function()
      vim.api.nvim_set_option_value('background', 'dark', {})
      -- require('catppuccin').setup {
      --   flavour = 'mocha', -- latte, frappe, macchiato, mocha
      -- }
      -- Load the colorscheme here
      vim.cmd 'colorscheme catppuccin-mocha'

      -- You can configure highlights by doing something like
      vim.cmd.hi 'Comment gui=none'
    end,
    set_light_mode = function()
      vim.api.nvim_set_option_value('background', 'light', {})
      -- require('catppuccin').setup {
      --   flavour = 'latte', -- latte, frappe, macchiato, mocha
      -- }
      -- Load the colorscheme here
      vim.cmd 'colorscheme catppuccin-latte'

      -- You can configure highlights by doing something like
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
