{ config, dotDir, ... }:

let
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotDir}/.config/ghostty/${path}";
in
{
  # Ghostty は設定の変更を config に直接書き戻す場合があるため、Nix store ではなく dotfiles へ直接リンクする。
  home.file = {
    ".config/ghostty/config".source = mkLink "config";
    ".config/ghostty/font.conf".source = mkLink "font.conf";
    ".config/ghostty/color.conf".source = mkLink "color.conf";
    ".config/ghostty/keybind.conf".source = mkLink "keybind.conf";
    ".config/ghostty/window.conf".source = mkLink "window.conf";
  };
}
