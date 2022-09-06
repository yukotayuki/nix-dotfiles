{ config, pkgs, lib, isLinux, dotDir, ... }:

let
  inherit (pkgs.stdenv) isLinux;

in lib.mkIf (isLinux) 
{
  home.packages = with pkgs; [ autokey ];
  xdg.configFile = {
    "autokey".source = config.lib.file.mkOutOfStoreSymlink "${dotDir}/.config/autokey";
    "autostart/autokey.desktop".source = config.lib.file.mkOutOfStoreSymlink "${dotDir}/.config/autostart/autokey.desktop";
  };
}
