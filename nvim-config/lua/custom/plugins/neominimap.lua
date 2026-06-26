-- Code minimap with diagnostics, git signs, search results, and marks

-- Custom handler: surface "MARK" section comments (// MARK:, # MARK, -- MARK, etc.)
-- in the minimap. neominimap's built-in `mark` feature only handles vim marks
-- (ma/'a), not code-comment section markers, so we add our own scanner.
local mark_comment_ns = vim.api.nvim_create_namespace 'neominimap_mark_comment'
local mark_label_ns = vim.api.nvim_create_namespace 'neominimap_mark_comment_label'
-- Built via nr2char so the multibyte glyph isn't mangled in source. 0x25c6 = ◆
-- (renders in virtually any font); swap for a nerd-font codepoint if preferred.
local mark_icon = vim.fn.nr2char(0x25c6)

local function set_mark_highlights()
  vim.api.nvim_set_hl(0, 'NeominimapMarkComment', { link = 'Special', default = true })
  vim.api.nvim_set_hl(0, 'NeominimapMarkCommentLabel', { link = 'NeominimapMarkComment', default = true })
end

-- Scan a buffer for "MARK" section comments and return { lnum, title } for each.
-- Matches a comment line whose content begins with the MARK token, e.g.
--   // MARK: - Section      # MARK setup      -- MARK: helpers      /* MARK */
-- Leading punctuation stands in for the comment leader; %f[%W] lets the token
-- end with ':', whitespace, or end-of-line. The title is whatever follows, with
-- the ':'/'-' separators and any trailing block-comment closer stripped (may be '').
local function scan_marks(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local marks = {}
  for i, line in ipairs(lines) do
    local rest = line:match '^%s*%p+%s*MARK%f[%W](.*)$'
    if rest then
      local title = rest:gsub('^[%s:%-]+', ''):gsub('[%s%*/%-]+$', '')
      marks[#marks + 1] = { lnum = i, title = title }
    end
  end
  return marks
end

local mark_comment_handler = {
  name = 'MARK comments',
  mode = 'icon',
  namespace = mark_comment_ns,
  init = function() end,
  autocmds = {
    {
      event = { 'BufWinEnter', 'TextChanged', 'InsertLeave' },
      opts = {
        desc = 'Update MARK-comment annotations',
        get_buffers = function(_)
          return vim.api.nvim_get_current_buf()
        end,
      },
    },
    {
      event = 'TabEnter',
      opts = {
        desc = 'Update MARK-comment annotations on tab enter',
        get_buffers = function(_)
          return require('neominimap.util').get_visible_buffers()
        end,
      },
    },
  },
  get_annotations = function(bufnr)
    local annotations = {}
    for _, m in ipairs(scan_marks(bufnr)) do
      annotations[#annotations + 1] = {
        lnum = m.lnum,
        end_lnum = m.lnum,
        id = 1,
        priority = 100,
        icon = mark_icon,
        highlight = 'NeominimapMarkComment',
      }
    end
    return annotations
  end,
}

-- The handler API only renders signs/icons/lines, not text. To show each mark's
-- title we overlay it directly onto the minimap buffer after every re-render,
-- mapping the source line to its compressed minimap row via the coord helper.
-- The icon lives in the sign column, so the overlaid text doesn't clobber it.
-- This must live in neominimap's own "Neominimap" augroup: the plugin fires the
-- event group-scoped, so a callback outside that group never runs.
local function register_label_overlay()
  local group = vim.api.nvim_create_augroup('Neominimap', { clear = false })
  vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = 'MinimapBufferTextUpdated',
    desc = 'Overlay MARK-comment titles on the minimap',
    callback = function(args)
      local src = args.data and args.data.buffer
      if not src or not vim.api.nvim_buf_is_valid(src) then
        return
      end
      local ok, buffer_map = pcall(require, 'neominimap.buffer.buffer_map')
      if not ok then
        return
      end
      local mbuf = buffer_map.get_minimap_bufnr(src)
      if not mbuf or not vim.api.nvim_buf_is_valid(mbuf) then
        return
      end
      local coord = require 'neominimap.map.coord'
      local line_count = vim.api.nvim_buf_line_count(mbuf)
      vim.api.nvim_buf_clear_namespace(mbuf, mark_label_ns, 0, -1)
      for _, m in ipairs(scan_marks(src)) do
        if m.title ~= '' then
          local mrow = coord.codepoint_to_mcodepoint(m.lnum, 1)
          if mrow >= 1 and mrow <= line_count then
            pcall(vim.api.nvim_buf_set_extmark, mbuf, mark_label_ns, mrow - 1, 0, {
              virt_text = { { m.title, 'NeominimapMarkCommentLabel' } },
              virt_text_pos = 'overlay',
              hl_mode = 'combine',
              priority = 200,
            })
          end
        end
      end
    end,
  })
end

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

    set_mark_highlights()
    vim.api.nvim_create_autocmd('ColorScheme', {
      desc = 'Re-link MARK-comment highlights after colorscheme change',
      callback = set_mark_highlights,
    })

    vim.g.neominimap = {
      handlers = { mark_comment_handler },
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
  -- Runs after the plugin is sourced (so the "Neominimap" augroup already exists).
  config = function()
    register_label_overlay()
  end,
}
