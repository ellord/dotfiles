vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
return {
  'stevearc/oil.nvim',
  opts = {
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
      -- This function defines what is considered a "hidden" file
      is_hidden_file = function(name, bufnr)
        -- List of files/patterns to always show
        local always_show = {
          '^%.env$',
          '^%.circleci$',
          '^%.config$',
          '^%.example%.env',
          '^%.example%.env%..*',
          '^%.eslintrc%.',
          '^%.prettierrc%.',
          '^%.babelrc%.',
          '^%.stylelintrc%.',
          '^%.npmrc$',
          '^%.yarnrc$',
          '^%.gitignore$',
          '^%.gitattributes$',
          '^%.editorconfig$',
        }

        -- Check if the file matches any of the always_show patterns
        for _, pattern in ipairs(always_show) do
          if name:match(pattern) then
            return false -- Not hidden
          end
        end

        -- Hide all other dot files
        return vim.startswith(name, '.')
      end,
    },
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- return vim.startswith(name, '.') and name ~= '.env' and name ~= '.config'
}
