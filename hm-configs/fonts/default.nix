{ config, pkgs, lib, isNixOS, ... }:

lib.mkIf (isNixOS)
{
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Noto" ]; })
  ];

  fonts.fontconfig.enable = true;
}
