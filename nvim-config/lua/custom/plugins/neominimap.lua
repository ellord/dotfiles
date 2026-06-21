-- Code minimap with diagnostics, git signs, search results, and marks
return {
  'Isrothy/neominimap.nvim',
  version = 'v3.x.x',
  lazy = false,
  keys = {
    { '<leader>nm', '<cmd>Neominimap Toggle<cr>', desc = 'Toggle global minimap' },
    { '<leader>no', '<cmd>Neominimap Enable<cr>', desc = 'Enable global minimap' },
    { '<leader>nc', '<cmd>Neominimap Disable<cr>', desc = 'Disable global minimap' },
    { '<leader>nr', '<cmd>Neominimap Refresh<cr>', desc = 'Refresh global minimap' },
    { '<leader>nf', '<cmd>Neominimap Focus<cr>', desc = 'Focus minimap' },
    { '<leader>nu', '<cmd>Neominimap Unfocus<cr>', desc = 'Unfocus minimap' },
    { '<leader>ns', '<cmd>Neominimap ToggleFocus<cr>', desc = 'Toggle minimap focus' },
  },
  init = function()
    vim.opt.wrap = false
    vim.opt.sidescrolloff = 36

    vim.g.neominimap = {
      auto_enable = true,
      layout = 'float',
      click = {
        enabled = true,
        auto_switch_focus = true,
      },
      diagnostic = {
        enabled = true,
        mode = 'line',
      },
      git = {
        enabled = true,
        mode = 'sign',
      },
      search = {
        enabled = true,
        mode = 'line',
      },
      mark = {
        enabled = true,
        mode = 'icon',
        show_builtins = true,
      },
      treesitter = {
        enabled = true,
      },
    }
  end,
}
