{ config, pkgs, lib, dotDir, ... }:

let
  inherit (pkgs.stdenv) isDarwin;
in lib.mkIf isDarwin {

  # karabiner.json を dotfiles からシンボリックリンクする。
  # home.file の source を使わない理由:
  #   home.file は nix store への symlink を作るため read-only になり、
  #   Karabiner が GUI 操作で設定を書き込めなくなる。
  #   home.activation で直接 symlink を張ることで書き込みを維持する。
  home.activation.karabinerConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/.config/karabiner/assets
    ln -sf ${dotDir}/.config/karabiner/karabiner.json \
      $HOME/.config/karabiner/karabiner.json
    # complex_modifications はディレクトリへの symlink にする。
    # mkdir -p で先に作ってしまうと ln -sf がディレクトリ内に symlink を作るため、
    # 先に rm してから symlink を張る。
    rm -rf $HOME/.config/karabiner/assets/complex_modifications
    ln -sf ${dotDir}/.config/karabiner/assets/complex_modifications \
      $HOME/.config/karabiner/assets/complex_modifications
  '';

}
