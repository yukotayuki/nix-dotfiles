{ config, pkgs, lib, ... }:


{
  home.packages = with pkgs; [
    duf
    dust
  ];
  programs = {
    htop = {
      enable = true;
    };
    bottom = {
      enable = true;
    };
  };
}
