vim.treesitter.stop()

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '\n call v:lua.vim.treesitter.start()'
