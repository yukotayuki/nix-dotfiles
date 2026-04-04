{ config, dotDir, ... }:

let
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotDir}/.config/ghostty/${path}";
in
{
  # mkOutOfStoreSymlink を使う理由:
  #   Ghostty は設定の変更を config に直接書き戻す場合があるため、
  #   Nix store への読み取り専用リンクではなく dotfiles への直接リンクにする。
  home.file = {
    ".config/ghostty/config".source      = mkLink "config";
    ".config/ghostty/font.conf".source   = mkLink "font.conf";
    ".config/ghostty/color.conf".source  = mkLink "color.conf";
    ".config/ghostty/keybind.conf".source = mkLink "keybind.conf";
    ".config/ghostty/window.conf".source = mkLink "window.conf";
  };
}
