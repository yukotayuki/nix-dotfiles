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
          sh = { 'shfmt' },
        },
        formatters = {
          shfmt = {
            -- -i 2: 2スペースインデント、-ci: case インデント、-bn: バイナリ演算子を行末に
            prepend_args = { '-i', '2', '-ci', '-bn' },
          },
        },
        format_on_save = { timeout_ms = 5000 },
      }
    end
  }
}
