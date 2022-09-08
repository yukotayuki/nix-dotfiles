{ config, pkgs, lib, ... }:

{
  programs = {
    wezterm.enable = true;
    alacritty.enable = true;
  };
}
