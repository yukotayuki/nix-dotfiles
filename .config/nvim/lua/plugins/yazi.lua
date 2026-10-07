return {
  {
    'mikavilpas/yazi.nvim',
    version = '*',
    event = 'VeryLazy',
    dependencies = {
      { 'nvim-lua/plenary.nvim', lazy = true },
    },
    -- open_for_directories で `nvim .` を yazi が引き受けるため netrw を読み込ませない。
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      open_for_directories = true,
      keymaps = {
        show_help = '<f1>',
      },
    },
    config = function(_, opts)
      require('yazi').setup(opts)
      -- 引数なしで nvim を起動した場合にカレントディレクトリで yazi を開く。
      if vim.fn.argc() == 0 then
        require('yazi').yazi(nil, vim.fn.getcwd())
      end
    end,
    keys = {
      -- 開いているファイルにカーソルを合わせて起動する。複数選択したファイルはすべて開く。
      { '<leader>y', '<cmd>Yazi<cr>', mode = { 'n', 'v' }, desc = 'Open yazi at the current file' },
      { ',f', '<cmd>Yazi<cr>', desc = 'Open yazi at the current file' },
    },
  },
}
