-- Obsidian.nvim: Note-taking and knowledge base management
-- Integrates with Obsidian vaults for link following, backlinks, daily notes, and search
-- Requires OBSIDIAN_VAULT_PATH env var to be set (e.g. in mise.personal.toml)
local vault_path = vim.env.OBSIDIAN_VAULT_PATH

if not vault_path then
  return {}
end

return {
  'epwalsh/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function()
        vim.opt_local.conceallevel = 2
      end,
    })
  end,
  opts = {
    workspaces = {
      {
        name = vim.fn.fnamemodify(vault_path, ':t'),
        path = vault_path,
      },
    },

    daily_notes = {
      folder = 'daily',
      date_format = '%Y/%m/%Y-%m-%d',
    },

    ui = {
      enable = true,
    },

    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    picker = {
      name = 'telescope.nvim',
    },

    follow_url_func = function(url)
      vim.fn.jobstart { 'open', url }
    end,
  },
  keys = {
    { '<leader>oo', '<cmd>ObsidianOpen<cr>', desc = '[O]bsidian [O]pen in app' },
    { '<leader>on', '<cmd>ObsidianNew<cr>', desc = '[O]bsidian [N]ew note' },
    { '<leader>os', '<cmd>ObsidianSearch<cr>', desc = '[O]bsidian [S]earch' },
    { '<leader>oq', '<cmd>ObsidianQuickSwitch<cr>', desc = '[O]bsidian [Q]uick switch' },
    { '<leader>ob', '<cmd>ObsidianBacklinks<cr>', desc = '[O]bsidian [B]acklinks' },
    { '<leader>od', '<cmd>ObsidianDailies<cr>', desc = '[O]bsidian [D]ailies' },
    { '<leader>ot', '<cmd>ObsidianToday<cr>', desc = '[O]bsidian [T]oday' },
    { '<leader>ol', '<cmd>ObsidianLinks<cr>', desc = '[O]bsidian [L]inks' },
    { '<leader>or', '<cmd>ObsidianRename<cr>', desc = '[O]bsidian [R]ename' },
  },
}
