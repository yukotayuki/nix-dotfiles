{ config, pkgs, lib, dotDir, isNixOS, ... }:

let
  inherit (pkgs.stdenv) isLinux;

in lib.mkIf (isLinux) 
{

  home.packages = with pkgs; [
  ] ++ lib.lists.optionals isNixOS [
    autokey
  ];
  xdg.configFile = {
    "autokey" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotDir}/.config/autokey";
    };
  } // lib.attrsets.optionalAttrs isNixOS {
    "autostart/autokey.desktop" =
    let
      autokey_desktop = "${dotDir}/.config/autostart/autokey.desktop";
    in
    {
      source = config.lib.file.mkOutOfStoreSymlink "${autokey_desktop}";
    };
  };
}
