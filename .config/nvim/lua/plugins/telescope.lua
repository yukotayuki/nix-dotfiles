return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      defaults = {
        -- treesitter ハイライトを使わない理由:
        --   nvim-treesitter の新バージョンで parsers.ft_to_lang が削除され、
        --   telescope の previewer がこれを呼び出してクラッシュする。
        --   vim の組み込みシンタックスで代替できるため影響は軽微。
        preview = { treesitter = false },
      },
    },
    keys = function()
      local builtin = require('telescope.builtin')
      return {
        { '<Space>ff', builtin.find_files },
        { '<Space>fg', builtin.live_grep },
        { '<Space>fb', builtin.buffers },
        { '<Space>fh', builtin.help_tags },
      }
    end
  }
}
