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
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- 全サーバー共通のケーパビリティ設定（nvim 0.11+ の vim.lsp.config API）
      vim.lsp.config('*', {
        capabilities = vim.tbl_deep_extend(
          'force',
          require('cmp_nvim_lsp').default_capabilities(),
          {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              }
            }
          }
        ),
      })

      -- biome は mason-lspconfig のハンドラーではなく npx 経由で起動する理由:
      --   mason でインストールした biome はプロジェクトローカルの biome と
      --   バージョンが異なる場合に競合するため、npx でプロジェクトの biome を使う。
      vim.lsp.config('biome', {
        cmd = { 'npx', 'biome', 'lsp-proxy' },
      })
      vim.lsp.enable('biome')

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            format = {
              defaultConfig = {
                quote_style = 'single',
              }
            },
            diagnostics = {
              globals = { 'vim' },
            }
          }
        }
      })

      require('mason-lspconfig').setup({
        ensure_installed = { 'lua_ls', 'ts_ls' },
        automatic_installation = true,
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    init = function()
      vim.diagnostic.config({
        virtual_text = {
          source = 'always',
        },
        float = {
          source = 'always',
        },
      })
    end,
  },
  {
    'nvimdev/lspsaga.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('lspsaga').setup({})
    end,
    opts = {
      lightbulb = {
        enable = false,
      },
      implement = {
        enable = true,
      },
    },
    keys = function()
      return {
        { 'K',  '<Cmd>Lspsaga hover_doc<CR>' },
        { ',c', '<Cmd>Lspsaga code_action<CR>',          mode = { 'n', 'v' } },
        { 'gr', '<Cmd>Lspsaga rename<CR>' },
        { 'gd', '<Cmd>Lspsaga goto_definition<CR>' },
        { 'gD', '<Cmd>Lspsaga peek_definition<CR>' },
        { 'gt', '<Cmd>Lspsaga goto_type_definition<CR>' },
        { 'gT', '<Cmd>Lspsaga peek_type_definition<CR>' },
        { ',t', '<Cmd>Lspsaga term_toggle<CR>' },
      }
    end
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      modes = {
        float_sitai = {
          focus = true,
          mode = 'diagnostics',
          preview = {
            type = 'float',
            relative = 'editor',
            border = 'rounded',
            title = 'Preview',
            title_pos = 'center',
            position = { 0, -2 },
            size = { width = 0.3, height = 0.3 },
            zindex = 200,
          },
        },
      },
    },
    keys = {
      { ',d',         '<cmd>Trouble float_sitai toggle<cr>' },
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>',              desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>',      desc = 'Symbols (Trouble)' },
      { '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references / ...' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>',                  desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>',                   desc = 'Quickfix List (Trouble)' },
    },
  },
}
