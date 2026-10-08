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
          nix = { 'nixfmt' },
          sh = { 'shfmt' },
        },
        -- prettier times out at 500 ms
        format_on_save = { timeout_ms = 5000 },
        formatters = {
          shfmt = {
            command = 'shfmt',
            -- prepend_args が推奨されているが、append_args でないと反映されない
            append_args = { '-i', '2', '-ci', '-bn' },
          },
        },
      }
    end
  }
}
