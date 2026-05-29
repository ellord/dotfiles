return {
  'zbirenbaum/copilot-cmp',
  config = function()
    require('copilot_cmp').setup()

    -- copilot-cmp is unmaintained and still calls `client.is_stopped()` with
    -- the deprecated dot-syntax, which emits a warning on every completion in
    -- Neovim 0.11+. Patch its source check to use the colon method form.
    local source = require('copilot_cmp.source')
    source.is_available = function(self)
      if self.client:is_stopped() or self.client.name ~= 'copilot' then
        return false
      end

      local clients = vim.lsp.get_clients {
        bufnr = vim.api.nvim_get_current_buf(),
        id = self.client.id,
      }
      return next(clients) ~= nil
    end
  end,
}
