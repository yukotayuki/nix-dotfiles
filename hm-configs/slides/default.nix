{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    slides
    graph-easy
  ];
}

