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
        -- nvim 0.12+ は markdown/markdown_inline を組み込みで提供するため除外
        ensure_installed = {
          'c', 'vim', 'lua',
          'javascript', 'typescript', 'toml', 'tmux',
          'json', 'yaml', 'html',
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  }
}
