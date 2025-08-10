return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    root_dir = require('lspconfig').util.root_pattern('package.json', 'tsconfig.json'),
    single_file_support = false,
    settings = {
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
