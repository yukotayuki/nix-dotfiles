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

  # mkOutOfStoreSymlink を使う理由:
  #   Karabiner は GUI 操作で設定を書き込むため、
  #   Nix store への読み取り専用リンクではなく dotfiles への直接リンクにする。
  home.file = {
    ".config/karabiner/karabiner.json".source = mkLink ".config/karabiner/karabiner.json";
    ".config/karabiner/assets/complex_modifications".source =
      mkLink ".config/karabiner/assets/complex_modifications";
  };

}
