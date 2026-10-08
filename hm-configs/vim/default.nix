{
  pkgs,
  lib,
  dotDir,
  ...
}:

let
  inherit (pkgs.stdenv) isLinux;
  settings = {
    enable = true;
    # extraLuaConfig は home-manager 生成の init.lua にコードを注入するが、lazy.nvim のブートストラップは自分が唯一のエントリポイントであることを前提とする。
    # luafile で呼び出せば init.lua が nix なしでも単独で動作する。
    extraConfig = ''
      set rtp^=${dotDir}/.config/nvim
      set rtp+=${dotDir}/.config/nvim/after
      luafile ${dotDir}/.config/nvim/init.lua
    '';
  };
in
{
  home.packages =
    with pkgs;
    [
      # nodejs: mason.nvim が ts_ls を npm 経由でインストールするために必要。
      # LSP サーバーは更新頻度が高いので、追加・更新のたびに darwin-rebuild が要らない mason で管理する。
      nodejs
      # tree-sitter: nvim-treesitter（main ブランチ）がパーサーをビルドするために必要（0.26.1 以上）。
      tree-sitter
    ]
    ++ lib.lists.optionals isLinux [
      xclip
    ];
  # general.lua の clipboard=unnamed で macOS では pbcopy/pbpaste が直接使われるため、reattach-to-user-namespace は不要。

  programs.neovim = settings;
  programs.vim = lib.mkIf isLinux settings;
}
