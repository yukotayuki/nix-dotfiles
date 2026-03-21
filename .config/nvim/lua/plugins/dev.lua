return {
  -- nvim-autopairs は completion.lua で nvim-cmp と統合して管理する。
  { 'windwp/nvim-ts-autotag', config = true },
  { 'JoosepAlviste/nvim-ts-context-commentstring' },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end
  },
  { 'kylechui/nvim-surround', version = '*', event = 'VeryLazy', config = true },
  {
    'shellRaining/hlchunk.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('hlchunk').setup({
        chunk = { enable = true },
        line_num = { enable = true },
      })
    end
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup()
      vim.keymap.set('n', '<Space>?', function() require('which-key').show({ global = false }) end)
    end
  },
}
