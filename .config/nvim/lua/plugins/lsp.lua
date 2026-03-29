return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
      -- shfmt は LSP サーバーではなくフォーマッタのため mason-lspconfig ではなく
      -- mason の MasonInstall で管理する。conform.lua の sh フォーマッタとセットで機能する。
      local mr = require('mason-registry')
      if not mr.is_installed('shfmt') then
        vim.cmd('MasonInstall shfmt')
      end
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      require('mason-lspconfig').setup({
        ensure_installed = { 'lua_ls', 'ts_ls' },
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({
              capabilities = capabilities,
            })
          end,
          -- biome は mason-lspconfig のハンドラーではなく npx 経由で起動する理由:
          --   mason でインストールした biome はプロジェクトローカルの biome と
          --   バージョンが異なる場合に競合するため、npx でプロジェクトの biome を使う。
          ['biome'] = function()
            require('lspconfig').biome.setup({
              capabilities = capabilities,
              cmd = { 'npx', 'biome', 'lsp-proxy' },
            })
          end,
        },
      })
    end
  },
  {
    'nvimdev/lspsaga.nvim',
    event = 'LspAttach',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lspsaga').setup()
      local set = vim.keymap.set
      set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>')
      set('n', ',c', '<Cmd>Lspsaga code_action<CR>')
      set('n', 'gr', '<Cmd>Lspsaga rename<CR>')
      set('n', 'gd', '<Cmd>Lspsaga goto_definition<CR>')
      set('n', 'gD', '<Cmd>Lspsaga peek_definition<CR>')
      set('n', 'gt', '<Cmd>Lspsaga goto_type_definition<CR>')
      set('n', 'gT', '<Cmd>Lspsaga peek_type_definition<CR>')
      set('n', ',t', '<Cmd>Lspsaga term_toggle<CR>')
    end
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('trouble').setup()
      vim.keymap.set('n', ',d', '<Cmd>Trouble diagnostics toggle filter.buf=0<CR>')
    end
  },
}
