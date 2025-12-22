-- nvim-spectre: Visual search and replace across files
-- Provides a modern UI for finding and replacing text across your codebase
-- Uses ripgrep for fast searching

return {
  'nvim-pack/nvim-spectre',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('spectre').setup {
      highlight = {
        ui = 'String',
        search = 'SpectreSearch',
        replace = 'SpectreReplace',
      },
      mapping = {
        ['send_to_qf'] = {
          map = '<leader>q',
          cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          desc = 'send all items to quickfix',
        },
      },
    }

    -- Open Spectre for project-wide search and replace
    vim.keymap.set('n', '<leader>sr', '<cmd>lua require("spectre").toggle()<CR>', {
      desc = '[S]earch & [R]eplace (Spectre)',
    })

    -- Search and replace the word under cursor
    vim.keymap.set('n', '<leader>srw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
      desc = '[S]earch & [R]eplace current [W]ord',
    })

    -- Search and replace in current file only
    vim.keymap.set('n', '<leader>srf', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
      desc = '[S]earch & [R]eplace in current [F]ile',
    })

    -- Search and replace visual selection
    vim.keymap.set('v', '<leader>sr', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
      desc = '[S]earch & [R]eplace selection',
    })
  end,
}
