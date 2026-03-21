return {
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    enabled = true,
    config = function()
      vim.g.everforest_background = 'soft'
      vim.cmd.colorscheme 'everforest'
    end
  }
}
