-- init.lua のあるディレクトリ（~/dotfiles/.config/nvim）を導出する。
-- performance.rtp.paths を使わない理由:
--   lazy.nvim は初期化時に rtp をリセットするため、extraConfig で追加した
--   ~/dotfiles/.config/nvim/after が消える。paths に明示することで保持する。
local dotfiles_nvim = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { import = "plugins" },
  ui = { border = "single" },
  -- rocks を有効にしない理由:
  --   lazy-rocks は luarocks パッケージをプラグインごとのディレクトリ
  --   （例: lazy-rocks/telescope.nvim/）に展開する。
  --   この際 package.path に予期しないプレフィックスが追加され、
  --   他プラグインのモジュールを上書きすることがある。
  --   実際に telescope の rocks パスが nvim-treesitter の lua ディレクトリより
  --   先に検索され、require('nvim-treesitter.configs') が失敗した。
  rocks = { enabled = false },
  performance = {
    rtp = {
      paths = { dotfiles_nvim .. "/after" },
    },
  },
})
