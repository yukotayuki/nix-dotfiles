return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    routes = {
      { view = 'mini', filter = { event = 'msg_show' } },
      { view = 'mini', filter = { warning = true } },
    },
  },
  dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' }
}
