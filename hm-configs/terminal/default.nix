{ config, pkgs, lib, isNixOS, ... }:

lib.mkIf (isNixOS)
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
