return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    -- Allow single file support to work outside projects
    single_file_support = true,
    settings = {
      -- Let the plugin auto-detect tsserver from local node_modules or global installation
      tsserver_path = nil,
      separate_diagnostic_server = true,
      publish_diagnostic_on = "insert_leave",
      typescript = {
        completion = {
          includeCompletionsForModuleExports = true,
          includeCompletionsWithSnippetText = false,
        },
      },
      javascript = {
        completion = {
          includeCompletionsForModuleExports = true,
          includeCompletionsWithSnippetText = false,
        },
      },
    },
  },
}
