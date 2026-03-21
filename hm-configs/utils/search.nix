{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    fd
  ];
  programs = {
    broot = {
      enable = true;
    };
    eza = {
      enable = true;
    };
  };
}
