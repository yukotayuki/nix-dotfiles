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
    # extraLuaConfig を使わない理由:
    #   extraLuaConfig は home-manager 生成の init.lua にコードを注入するが、
    #   lazy.nvim のブートストラップは自分が唯一のエントリポイントであることを前提とする。
    #   luafile で呼び出す方式なら init.lua が nix なしでも単独で動作する。
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
      # LSP サーバーを nix で管理しない理由:
      #   mason に任せると LSP の追加・更新のたびに darwin-rebuild が不要になる。
      #   更新頻度の高い LSP サーバーは mason 管理の方がコストが低い。
      nodejs
    ]
    ++ lib.lists.optionals isLinux [
      xclip
    ];
  # reattach-to-user-namespace を使わない理由:
  #   neovim の general.lua で clipboard=unnamed を設定しており、
  #   macOS では pbcopy/pbpaste が直接使われるため不要。
  #   tmux 側も copy-command = pbcopy に移行済み。

  programs.neovim = settings;
  programs.vim = lib.mkIf isLinux settings;
}
