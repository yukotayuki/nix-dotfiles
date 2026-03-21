return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    opts = function()
      local js_formatters = { 'biome-check', 'prettier', stop_after_first = true }
      return {
        formatters_by_ft = {
          javascript = js_formatters,
          typescript = js_formatters,
          json = js_formatters,
          lua = { lsp_format = 'fallback' },
        },
        format_on_save = { timeout_ms = 5000 },
      }
    end
  }
}
