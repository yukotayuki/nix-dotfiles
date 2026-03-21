return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    build = ':TSUpdate',
    dependencies = { 'nvim-treesitter/nvim-treesitter-context' },
    config = function()
      local ok, configs = pcall(require, 'nvim-treesitter.configs')
      if not ok then return end
      configs.setup({
        ensure_installed = {
          'c', 'vim', 'lua', 'markdown',
          'javascript', 'typescript', 'toml', 'tmux',
          'json', 'yaml', 'html',
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  }
}
