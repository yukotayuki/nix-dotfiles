{ config, pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isLinux;

in lib.mkIf (isLinux)
{
  programs = {
    wezterm.enable = true;
    alacritty.enable = true;
  };
}
