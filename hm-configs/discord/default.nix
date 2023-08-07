{ config, pkgs, lib, isNixOS, ... }:

lib.mkIf (isNixOS)
{
  home.packages = with pkgs; [
    discord
  ];
}
