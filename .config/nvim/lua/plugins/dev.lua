return {
  -- nvim-autopairs は completion.lua で nvim-cmp と統合して管理する。
  { 'windwp/nvim-ts-autotag', config = true },
  {
    -- コメントは nvim 標準の gc を使い、vue の template と script のように場所で変わるコメント記号をこのプラグインで決める。
    'JoosepAlviste/nvim-ts-context-commentstring',
    opts = { enable_autocmd = false },
    init = function()
      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == 'commentstring'
          and require('ts_context_commentstring.internal').calculate_commentstring()
          or get_option(filetype, option)
      end
    end,
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
