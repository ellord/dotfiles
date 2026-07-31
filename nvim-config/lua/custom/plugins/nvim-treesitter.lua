-- Highlight, edit, and navigate code
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main', -- config below uses the rewritten `main`-branch API (`.install`,
  -- `.get_installed()`, `.get_available()`); the legacy `master` branch lacks these.
  -- Pinned explicitly because lazy.nvim won't migrate an existing clone across a
  -- branch even after the upstream default branch changes.
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function()
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    -- nvim-treesitter `main` branch: parsers are installed via `.install`,
    -- and highlight/indent are enabled per-buffer on FileType. The old
    -- module-based `highlight`/`indent`/`auto_install` tables are gone.
    local ts = require 'nvim-treesitter'

    ts.install { 'bash', 'c', 'html', 'lua', 'markdown', 'markdown_inline', 'vim', 'vimdoc' }

    vim.api.nvim_create_autocmd('FileType', {
      desc = 'Enable treesitter highlighting and indentation',
      callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        -- Preserve the previous `disable = { 'markdown' }` for both.
        if ft == 'markdown' then
          return
        end

        -- Approximate the old `auto_install = true`: install a missing
        -- parser in the background when one is available upstream.
        local lang = vim.treesitter.language.get_lang(ft) or ft
        if not vim.tbl_contains(ts.get_installed(), lang) and vim.tbl_contains(ts.get_available(), lang) then
          ts.install(lang)
        end

        if pcall(vim.treesitter.start, buf) then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    require('nvim-treesitter-textobjects').setup {
      move = { set_jumps = true },
    }

    local move = require 'nvim-treesitter-textobjects.move'
    vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
      move.goto_next_start('@function.outer')
    end, { desc = 'Next method/function' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
      move.goto_previous_start('@function.outer')
    end, { desc = 'Previous method/function' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
      move.goto_next_end('@function.outer')
    end, { desc = 'Next method/function end' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
      move.goto_previous_end('@function.outer')
    end, { desc = 'Previous method/function end' })

    -- `;`/`,` repeat the last registered move: the treesitter motions above
    -- (registered automatically), git hunk jumps (gitsigns.lua), and
    -- diagnostic jumps (init.lua)
    local repeat_move = require 'nvim-treesitter-textobjects.repeatable_move'
    vim.keymap.set({ 'n', 'x', 'o' }, ';', repeat_move.repeat_last_move_next, { desc = 'Repeat last move forward' })
    vim.keymap.set({ 'n', 'x', 'o' }, ',', repeat_move.repeat_last_move_previous, { desc = 'Repeat last move backward' })

    -- f/F/t/T must go through the same registry, otherwise `;`/`,` lose
    -- their native char-repeat behaviour
    vim.keymap.set({ 'n', 'x', 'o' }, 'f', repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'F', repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 't', repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'T', repeat_move.builtin_T_expr, { expr = true })

    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  end,
}
