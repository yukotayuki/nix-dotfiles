{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    wget
    curl
    curlie
    dog
  ];
}

