return {
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<Space>ff', function() require('telescope.builtin').find_files() end },
      { '<Space>fg', function() require('telescope.builtin').live_grep() end },
      { '<Space>fb', function() require('telescope.builtin').buffers() end },
      { '<Space>fh', function() require('telescope.builtin').help_tags() end },
    },
  }
}
