return {
  'otavioschwanck/arrow.nvim',
  opts = {
    show_icons = true,
    separate_by_branch = true,
    leader_key = ';', -- Recommended to be a single key
    buffer_leader_key = 'm', -- Per Buffer Mappings
  },
  config = function(_, opts)
    require('arrow').setup(opts)

    -- Detect the base branch for the current PR or fall back to common defaults
    local function detect_base_branch()
      if vim.fn.executable 'gh' == 1 then
        local pr_base = vim.fn.system 'gh pr view --json baseRefName -q .baseRefName 2>/dev/null'
        pr_base = vim.trim(pr_base)
        if vim.v.shell_error == 0 and pr_base ~= '' then
          return pr_base
        end
      end
      for _, branch in ipairs { 'develop', 'main', 'master' } do
        vim.fn.system('git rev-parse --verify ' .. branch .. ' 2>/dev/null')
        if vim.v.shell_error == 0 then
          return branch
        end
      end
      return 'develop'
    end

    local MAX_ARROW_DIFF_FILES = 30

    -- Add all files from the branch diff to Arrow bookmarks
    local function arrow_diff(base_branch)
      base_branch = base_branch or detect_base_branch()
      local result = vim.fn.systemlist('git diff --name-only ' .. vim.fn.shellescape(base_branch) .. '...HEAD')
      if vim.v.shell_error ~= 0 then
        vim.notify('ArrowDiff: git diff failed (is ' .. base_branch .. ' a valid branch?)', vim.log.levels.ERROR)
        return
      end
      local files = vim.tbl_filter(function(f)
        return f ~= ''
      end, result)
      if #files == 0 then
        vim.notify('ArrowDiff: no changed files found vs ' .. base_branch, vim.log.levels.WARN)
        return
      end
      if #files > MAX_ARROW_DIFF_FILES then
        vim.notify(
          string.format('ArrowDiff: %d files found vs %s, capping at %d', #files, base_branch, MAX_ARROW_DIFF_FILES),
          vim.log.levels.WARN
        )
        files = vim.list_slice(files, 1, MAX_ARROW_DIFF_FILES)
      end
      local persist = require 'arrow.persist'
      local added = 0
      for _, file in ipairs(files) do
        if not persist.is_saved(file) then
          persist.save(file)
          added = added + 1
        end
      end
      vim.notify(string.format('Arrow: added %d files (vs %s)', added, base_branch))
    end

    vim.api.nvim_create_user_command('ArrowDiff', function(cmd)
      arrow_diff(cmd.args ~= '' and cmd.args or nil)
    end, { nargs = '?', desc = 'Add git diff files to Arrow bookmarks' })

    vim.keymap.set('n', '<leader>B', function()
      arrow_diff()
    end, { desc = 'Arrow: bookmark branch diff files' })
  end,
}
