-- master ブランチを使わない理由:
--   master は Neovim 0.12 に非対応で、Markdown を開くとコードブロックの言語判定（set-lang-from-info-string!）でエラーになる。
--   main ブランチはパーサーとクエリのインストールだけを担い、ハイライトやインデントは FileType で自分で有効にする。
local parsers = {
  'c', 'vim', 'lua', 'markdown', 'markdown_inline',
  'javascript', 'typescript', 'tsx', 'toml',
  'json', 'yaml', 'html', 'css',
  'nix', 'bash', 'python', 'go',
  'terraform', 'hcl', 'dockerfile',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    -- main は遅延読み込みに対応していない
    lazy = false,
    build = ':TSUpdate',
    dependencies = { 'nvim-treesitter/nvim-treesitter-context' },
    config = function()
      require('nvim-treesitter').install(parsers)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          -- vim.treesitter.start は従来の syntax を止めるため、ハイライトのクエリが無い言語では有効にせず syntax のまま残す。
          -- master の頃に入れたパーサーがプラグインのディレクトリに残っているため、パーサーはあるがクエリが無い言語で色が消えるのを防ぐ。
          local ok, highlights = pcall(vim.treesitter.query.get, lang or '', 'highlights')
          if not lang or not ok or not highlights then
            return
          end
          if not pcall(vim.treesitter.start, args.buf, lang) then
            return
          end
          -- インデント用のクエリがある言語だけ treesitter のインデントを使う
          if vim.treesitter.query.get(lang, 'indents') then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end
  }
}
