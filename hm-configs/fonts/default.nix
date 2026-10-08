{
  pkgs,
  lib,
  isNixOS,
  ...
}:

lib.mkIf isNixOS {
  home.packages = with pkgs; [
    nerd-fonts.noto
  ];

  fonts.fontconfig.enable = true;
}
