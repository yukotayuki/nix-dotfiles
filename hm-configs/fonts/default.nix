{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Noto" ]; })
  ];

  fonts.fontconfig.enable = true;
}
