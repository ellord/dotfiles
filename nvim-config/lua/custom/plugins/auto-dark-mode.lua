return {
  'f-person/auto-dark-mode.nvim',
  opts = {
    update_interval = 1000,
    set_dark_mode = function()
      -- Load the colorscheme here
      require('catppuccin').setup {
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        transparent_background = true,
      }
      vim.cmd.colorscheme 'catppuccin'

      -- Force transparent background
      vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })

      -- You can configure highlights by doing something like
      vim.cmd.hi 'Comment gui=none'
    end,
    set_light_mode = function()
      require('catppuccin').setup {
        flavour = 'latte', -- latte, frappe, macchiato, mocha
        transparent_background = true,
      }
      vim.cmd.colorscheme 'catppuccin'

      -- Force transparent background
      vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })

      -- You can configure highlights by doing something like
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
