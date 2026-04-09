-- MARK: Leader Key
-- Must happen before plugins are loaded
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- MARK: Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.termguicolors = true
vim.opt.linespace = 4
vim.o.winborder = 'rounded'

-- MARK: Keymaps
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-q>', '<C-\\><C-n><C-w>h', { desc = 'Exit terminal and go to left window' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Black hole delete
vim.keymap.set('n', '<leader>x', '"_d', { desc = 'Delete without yanking' })

-- Live grep with args
vim.keymap.set('n', '<leader>fg', function()
  require('telescope').extensions.live_grep_args.live_grep_args()
end, { desc = 'Live grep with args' })

-- Splits
vim.keymap.set('n', '<leader>t-', ':split<CR>', { desc = 'Horizontal split', silent = true })
vim.keymap.set('n', '<leader>t|', ':vsplit<CR>', { desc = 'Vertical split', silent = true })
vim.keymap.set('n', '<leader>t;', ':close<CR>', { desc = 'Close split', silent = true })

-- Copy relative file path
vim.keymap.set('n', '<leader>cy', function()
  local relative_path = vim.fn.fnamemodify(vim.fn.expand '%', ':.')
  vim.fn.setreg('+', relative_path)
  vim.notify('Copied: ' .. relative_path)
end, { desc = 'Copy relative file path' })

-- MARK: Autocommands
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- MARK: Lazy.nvim Bootstrap
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- MARK: Plugins
require('lazy').setup {
  { import = 'custom.plugins' },
}

-- MARK: Filetype Registration
vim.filetype.add { extension = { templ = 'templ' } }

-- MARK: Highlight Overrides
vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE', fg = '#6c7086' })
