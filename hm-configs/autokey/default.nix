{ config, pkgs, lib, dotDir, ... }:

let
  inherit (pkgs.stdenv) isLinux;

in lib.mkIf (isLinux) 
{
  home.packages = with pkgs; [ autokey ];
  xdg.configFile = {
    "autokey" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotDir}/.config/autokey";
    };

    "autostart/autokey.desktop" =
    let
      autokey_desktop = "${dotDir}/.config/autostart/autokey.desktop";
    in
    {
      source = config.lib.file.mkOutOfStoreSymlink "${autokey_desktop}";
    };
  };
}
