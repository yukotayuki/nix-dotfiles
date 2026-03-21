return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
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
