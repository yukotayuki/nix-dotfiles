{ config, pkgs, lib, ... }:


{
  home.packages = with pkgs; [
    duf
    du-dust
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
