local M = {}

local function get_mark_items(bufnr)
  bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr

  local config = require 'todo-comments.config'
  local highlight = require 'todo-comments.highlight'
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local items = {}

  for lnum, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    local ok, start_col, end_col, keyword = pcall(highlight.match, line)

    if ok and start_col and keyword == 'MARK' then
      local is_comment = true
      if config.options.highlight.comments_only then
        is_comment = highlight.is_comment(bufnr, lnum - 1, start_col - 1) == true
      end

      if is_comment then
        table.insert(items, {
          bufnr = bufnr,
          filename = filename,
          lnum = lnum,
          col = start_col,
          text = vim.trim(line:sub(start_col)),
        })
      end
    end
  end

  return items
end

function M.open_picker(opts)
  opts = opts or {}

  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local items = get_mark_items(bufnr)

  if vim.tbl_isempty(items) then
    vim.notify('No MARK comments in the current buffer', vim.log.levels.INFO)
    return
  end

  pickers
    .new(opts, {
      prompt_title = 'MARK comments',
      finder = finders.new_table {
        results = items,
        entry_maker = function(item)
          return {
            value = item,
            ordinal = string.format('%06d %s', item.lnum, item.text),
            display = string.format('%4d  %s', item.lnum, item.text),
            filename = item.filename,
            lnum = item.lnum,
            col = item.col,
          }
        end,
      },
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if not selection then
            return
          end

          vim.api.nvim_set_current_buf(selection.value.bufnr)
          vim.api.nvim_win_set_cursor(0, { selection.value.lnum, math.max(selection.value.col - 1, 0) })
          vim.cmd 'normal! zz'
        end)

        return true
      end,
    })
    :find()
end

return M
