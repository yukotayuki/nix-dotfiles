{ config, pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isLinux;

in lib.mkIf (isLinux)
{
  home.packages = with pkgs; [
    discord
  ];
}