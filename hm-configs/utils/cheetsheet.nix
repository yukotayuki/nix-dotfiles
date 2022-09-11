{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    cheat
    tldr
  ];
}

