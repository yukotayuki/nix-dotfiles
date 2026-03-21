return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        extensions = { 'neo-tree' },
      })
    end
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup({
        options = {
          numbers = 'ordinal',
          diagnostics = 'nvim_lsp',
        }
      })
      vim.keymap.set('n', 'tt', '<Cmd>enew<CR>')
      vim.keymap.set('n', 'tn', '<Cmd>BufferLineCycleNext<CR>')
      vim.keymap.set('n', 'tp', '<Cmd>BufferLineCyclePrev<CR>')
      vim.keymap.set('n', 'tc', '<Cmd>bdelete<CR>')
    end
  },
  {
    'b0o/incline.nvim',
    config = function()
      require('incline').setup()
    end
  },
}
