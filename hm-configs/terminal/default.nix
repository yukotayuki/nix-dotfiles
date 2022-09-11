{ config, pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isLinux;

in lib.mkIf (isLinux)
{
  programs = {
    wezterm.enable = true;
    alacritty.enable = true;
  };
  home.file = {
    ".local/share/xfce4/terminal/colorschemes/nord.theme" = {
      source = ./theme/nord.theme;
    };
  };
}
