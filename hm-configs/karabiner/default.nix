{
  config,
  pkgs,
  lib,
  dotDir,
  ...
}:

let
  inherit (pkgs.stdenv) isDarwin;
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotDir}/${path}";
in
lib.mkIf isDarwin {

  # Karabiner は GUI 操作で設定を書き込むため、Nix store ではなく dotfiles へ直接リンクする。
  home.file = {
    ".config/karabiner/karabiner.json".source = mkLink ".config/karabiner/karabiner.json";
    ".config/karabiner/assets/complex_modifications".source =
      mkLink ".config/karabiner/assets/complex_modifications";
  };

}
