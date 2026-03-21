{ config, lib, dotDir, ... }:

let
  inherit (lib.hm.dag) entryAfter;
in
{
  # home.file を使わない理由:
  #   Ghostty は設定の変更を config に直接書き戻す場合があるため、
  #   Nix store への読み取り専用リンクではなく dotfiles への直接リンクにする。
  home.activation.ghosttyConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/.config/ghostty
    ln -sf ${dotDir}/.config/ghostty/config $HOME/.config/ghostty/config
  '';
}
